Return-Path: <linux-kernel-owner+w=401wt.eu-S1762131AbXIZSwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762131AbXIZSwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761238AbXIZSwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:52:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:56714 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760400AbXIZSwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ONAcDtMRe1QP7/7jS2YSJLSpxUnRQz6fAktjFzJ70ObSjjuEpwwUImgEspiolvj8pxD9g9wtNJ7CauOBBo+oui3JqG8Ev8IkJcw31zZkme54otT6iEoBACrO+UHFTMvZVTWjQS8vh0ZzvNr8hKPFVqBbN8BDhAnMyTzyV8inK70=
Date: Wed, 26 Sep 2007 22:52:08 +0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm1: ata3: soft resetting link after STR
Message-ID: <20070926185208.GA1753@martell.zuzino.mipt.ru>
References: <20070925205006.GA1766@martell.zuzino.mipt.ru> <1190756717.17409.80.camel@chaos> <20070926091412.GA1752@martell.zuzino.mipt.ru> <1190788997.23376.9.camel@chaos> <20070926153901.GA1746@martell.zuzino.mipt.ru> <20070926170020.195de7f7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926170020.195de7f7@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 05:00:20PM +0100, Alan Cox wrote:
> On Wed, 26 Sep 2007 19:39:01 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Frequently get these messages after resume from STR,
> > (subjectively, first STR is always OK).
> 
> Does this occur if you have the acpi support enabled
> (libata.noacpi=0)

I resumed ~20 times and there weren't any.

What did happened 3 times is hang on resume right after
message:

	Radeon 9600 256MB 1002 pa711eab.iee 817d33
	 _
	 ^ cursor here

with HDD LED is on. Never saw this on mainline.
(this is probably separate bug)
