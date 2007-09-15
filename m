Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXIONsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXIONsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXIONry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:47:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:10654 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbXIONrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZiFjHPZvLIHWsMpEoSTKxNpc8m7f0TxNuTHIBK8pByzgdu/105Mjf1WLcSxxZPY8eXoRVD19D6bi69gQcamMNje7CBl7IzcofSAu27Z8zKrfIKxSMeiKWQT8j+EV74BV7iBdUHo++9VVwSzxIrvrfk9fB3Bt8/YbBEMsYw8I1tQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
Date: Sat, 15 Sep 2007 14:47:44 +0100
User-Agent: KMail/1.9.1
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Sam Ravnborg <sam@ravnborg.org>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <200709141848.06027.vda.linux@googlemail.com> <200709151242.38464.vda.linux@googlemail.com> <jeps0kyue5.fsf@sykes.suse.de>
In-Reply-To: <jeps0kyue5.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709151447.44890.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007 13:40, Andreas Schwab wrote:
> Denys Vlasenko <vda.linux@googlemail.com> writes:
> 
> > ELF is not as rigid as old a.out (which had only one text, one data
> > and one bss segment per .o file IIRC), but size was born in a.out days,
> > so it sort of "translates" ELF into a.out.
> 
> Try size -A instead.

thanks, didn't know that.

$ size -A busybox
busybox  :
section       size        addr
.init           28   134512788
.text       633051   134512816
.fini           23   135145867
.rodata     139422   135145904
.eh_frame      156   135285328
.ctors           8   135286784
.dtors           8   135286792
.jcr             4   135286800
.got.plt        12   135286804
.data         1019   135286816
.bss         10724   135287840
Total       784455

addr in decimal?! wow...
--
vda
