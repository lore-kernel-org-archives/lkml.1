Return-Path: <linux-kernel-owner+w=401wt.eu-S2992790AbXDRV3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992790AbXDRV3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992793AbXDRV3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:29:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:39250 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992790AbXDRV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TmKaxmHiS1+4CiRUkYrvqrq+ZuaJXp+35X/l6NGywrFdlbQ1vrXMGcIK/uzDDlvSvLNgEF0G1FSpMi7hFXL+o2LbuJLm9hhOHgIALx728jlqfqA98OGE/yGvaNu4SqK8Dp8oF9PUv+Crwq5RfthmOYE/5HXea1Dy95lwwAT9hhU=
Message-ID: <87f94c370704181429y24a727ffl44aa8f318b4619a3@mail.gmail.com>
Date: Wed, 18 Apr 2007 17:29:18 -0400
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: "Chuck Ebbert" <cebbert@redhat.com>, "Mark Lord" <liml@rtr.ca>,
       Stephen.Clark@seclark.us, "Tejun Heo" <htejun@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       emisca <emisca.ml@gmail.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       "Adrian Bunk" <bunk@stusta.de>, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <200704182322.20514.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <88SeR-5Sf-15@gated-at.bofh.it> <46265307.7060405@rtr.ca>
	 <46265966.1040102@redhat.com> <200704182322.20514.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
> On Wednesday 18 April 2007, Chuck Ebbert wrote:
> > Mark Lord wrote:
> > > Mark Lord wrote:
> > >>
> > >> With the patch applied, I don't see *any* new activity in those
> > >> S.M.A.R.T.
> > >> attributes over multiple hibernates (Linux "suspend-to-disk").
> > >
> > > Scratch that -- operator failure.  ;)
> > > The patch makes no difference over hibernates in the SMART logs.
> > >
> > > It's still logging extra Power-Off_Retract_Count pegs,
> > > which it DID NOT USED TO DO not so long ago.
> > >
> >
> > Just to add to the fun, my problems are happening with the "old"
> > IDE drivers...
>
> The issue you are experiencing results in the same problem (disk doing
> power off retract) but it has a totally different root cause - your notebook
> loses power on reboot.  It is actually a hardware problem and as you have
> reported the same problem is present when using "the other" OS.
>
> I think that the issue needs to be fixed (by detecting affected notebook(s)
> using DMI?) in Linux PM handling and not in IDE subsystem because:
>
> * there may be some other hardware devices affected by the power loss
>   (== they require shutdown sequence)
>
> * the same problem will bite if somebody decides to use libata (FC7?)
>
> Bart

OpenSUSE 10.3 is still in Alpha stage (at least a few months away from
release), but they too have switched to libata by default.  (You can
override by adding a boot param).

Greg
-- 
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
