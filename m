Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbYAKX6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbYAKX6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYAKX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:58:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:35987 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbYAKX6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=vT5imrGs2R7f0Jd6MIDKexP/NKDfh2vGJvjNA7FGpIlleCF3O3XF/dU31JwdfRJTjbqXlAv8/vLUkbSrcqeSIciLieEsF/2J9Or1B9Kr+R4N7vea8fhksqSUoIxPqbrR3PEtY0vnfMJ2xRc01Ix4PV5vn+73e+6BmTxaQ8jrqeU=
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: hwclock failure in x86.git
Date: Sat, 12 Jan 2008 00:58:04 +0100
User-Agent: KMail/1.9.7
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4786AA11.5010805@gmail.com> <20080110220444.4c9efdec.kjwinchester@gmail.com> <20080111140346.GA13604@elte.hu>
In-Reply-To: <20080111140346.GA13604@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801120058.05398.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008 15:03:47 Ingo Molnar wrote:
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> > Bisect says...
> >
> > 4b5ea240a0c05ff90c4959fd91f0caec7b9bef1b is first bad commit
> > commit 4b5ea240a0c05ff90c4959fd91f0caec7b9bef1b
> > Author: mboton@gmail.com <mboton@gmail.com>
> > Date:   Wed Jan 9 13:31:11 2008 +0100
> >
> >     x86: ioport_{32|64}.c unification
>
> thanks for tracking it down. I pulled that commit for now. But it would
> be nice to figure out what's going on there.
>
> 	Ingo

mmm, i'll try to reproduce it tomorrow and find a fix.

thanks for notifying this problem.
-- 
	Miguel Botón
