Return-Path: <linux-kernel-owner+w=401wt.eu-S1765687AbYBMKTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765687AbYBMKTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYBMKTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:19:12 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:14333 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbYBMKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:19:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xakU+3JVAN2CEROhBjaYgJQcLWONYzPpanEqBOEbA10XcaGFJPDsLLluSQN+fdlCquLpJ5HX8FLF/hkTF6HWGWEzvAQrNxSbSCw1p63vJBNiwbXI9789fSSWSeUV6V2E/1DDFXYDVvxt+O+nCPBp1pPUwSDm3ovypo1zcmHgAbc=
Message-ID: <877aabc40802130219kab435d2o819e8534258640ef@mail.gmail.com>
Date: Wed, 13 Feb 2008 15:49:10 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Cc: "Jiri Kosina" <jkosina@suse.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Sergey Vlasov" <vsu@altlinux.ru>
In-Reply-To: <20080213085627.GA20765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080130011550.GA31853@elte.hu>
	 <f77718aa0802090611n240bfa5avbbe2abeb53607f48@mail.gmail.com>
	 <Pine.LNX.4.64.0802101326270.7699@twin.jikos.cz>
	 <877aabc40802112316t21d03114mc5b1f0411c019955@mail.gmail.com>
	 <20080213085627.GA20765@elte.hu>
X-Google-Sender-Auth: 42ebfe31eab671e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 2:26 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Amit Shah <amitshah@gmx.net> wrote:
>
> > > As far as I remembers, Ubuntu uses klibc in initramfs, right?
> > >
> > > What version of klibc do you have? There was a bug in klibc that
> > > causes such behavior on PIE-randomization-enabled kernels, and has
> > > been fixed in klibc-1.45 by commit [1]. Please make sure you have
> > > updated klibc version that doesn't contain this bug.
> >
> > Thanks Jiri.
>
> so your problem was resolved by an updated klibc version?

Yes, it was. I downloaded the sources from the gutsy repo (which is version 1.5)

-- 
Amit Shah
http://www.amitshah.net/
