Return-Path: <linux-kernel-owner+w=401wt.eu-S1767389AbXCIQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767389AbXCIQsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767392AbXCIQsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:48:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:15487 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767389AbXCIQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:48:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t28AL7bM5Pkl7q5YzpKSfPL78nfV2i3xutf7R+T2IWZdlf2ddZ3dDnH0VXhXB8XvxqxJ0zgg0F8xZN9nr0327KODTko1ccBNBtowbsTg1oxrKwx/lpyPSdOjV6hXtq48dyvaHJ7DT0mfGSHwn5XgORBRMumXvM4aLboRT/StcjY=
Message-ID: <4af2d03a0703090848g67b77f78ie98e359bbd97d5ca@mail.gmail.com>
Date: Fri, 9 Mar 2007 17:48:27 +0100
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Richard Purdie" <rpurdie@rpsys.net>
In-Reply-To: <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com>
	 <20070303094125.838ce04d.akpm@linux-foundation.org>
	 <45F13791.8040408@gmail.com>
	 <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com>
	 <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz>
	 <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Fri, 9 Mar 2007, Jiri Kosina wrote:
>
> > If this is present also in vanilla and not only in -mm, could you please
> > try reverting commits 4237081e573b99a48991aa71364b0682c444651c and
> > d4ae650a904612ffb7edd3f28b69b022988d2466 and let me know if the
> > situation gets any better?
>
> Hi Jiri,

Hi.

> or even better, does the patch below (against 2.6.21-rc3) fix the problem
> with your keyboard? I can see possibilities of report fields unaligned to
> the byte boundary, which this might be causing problems.

I'll try it all.

I don't know if this is related, but my notebook keyboard doesn't emit
numbers with numlock (not even directly Fn+blue number) anymore with
-rc3 (note that LED is flashing when numlock is on). I think -rc2
worked fine (I'm going to check this too). It's Asus M6R, similar
(except wi-fi) to for example yenya's model here:
http://www.fi.muni.cz/~kas/m6r/

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
