Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZKLPFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZKLPFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZKLPFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:05:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45714 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZKLPFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WsLihd0+6pZ4Kh2DRdcaOjvTvdLl5H5i0HyhqvP5SHVAZzbrOJZzkEqKoew1ioh9cS
         ecE1JO1MXR4jGroO2eMqV3qC4fygE65q3WVZAvpfg1ghKJVsaGFsrQig2ehUZTxysHOi
         P4CN5DEof6hNFYnYWcXMsegS+VQ3AOW8s/AW0=
Date: Thu, 12 Nov 2009 16:05:43 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, ucode-amd: Load ucode-patches once and not
 separately fo each CPU
Message-ID: <20091112150543.GH18592@alberich.amd.com>
References: <20091110110601.GG30802@alberich.amd.com>
 <20091110110723.GH30802@alberich.amd.com>
 <b647ffbd0911100402k4f8648b8ref712f4c60fb8a7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0911100402k4f8648b8ref712f4c60fb8a7b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 01:02:39PM +0100, Dmitry Adamushko wrote:
> 2009/11/10 Andreas Herrmann <herrmann.der.user@googlemail.com>:
> > This also implies that corresponding log messages, e.g.
> >
> >  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
> >
> > show up only once on module load and not when ucode is updated for
> > each CPU.
> 
> I like it.
> 
> One remark : should we perhaps provide a means of reloading the cached
> firmware?

I'll think about this.

> Or is the standard procedure to reload microcode.ko in case
> a new firmware file has been installed?

module reload will do so far.

(And I should ensure that microcode_amd is only provided if ucode
loader is compiled as module.)


Regards,
Andreas
