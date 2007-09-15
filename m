Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbXIOLmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbXIOLmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 07:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXIOLmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 07:42:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:24296 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXIOLmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 07:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GEyvxaYoT7XWhMVefbAY6PpkxncLdTAvs3C5I/ogPK8i9JcEiH46rbvT/InJAZVWDNPVkTd/UblYn4ObljFea64SjMs+vnPVqaUjKlU2ZQmG1NSqz/dchGg4iEgkfG6p/6LHJu57B0GWgFvdRA3w0bEf9tHiUUGhxVhxFv/Q++8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
Date: Sat, 15 Sep 2007 12:42:38 +0100
User-Agent: KMail/1.9.1
Cc: Sam Ravnborg <sam@ravnborg.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
References: <200709141848.06027.vda.linux@googlemail.com> <20070915101811.GA9934@uranus.ravnborg.org> <Pine.LNX.4.64.0709151228360.13411@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709151228360.13411@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709151242.38464.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007 11:29, Jan Engelhardt wrote:
 
> On Sep 15 2007 12:18, Sam Ravnborg wrote:
> >> >   text    data     bss     dec     hex filename
> >> > 106315  179564      36  285915   45cdb snd-hda-intel.o
> >> > 283051    2624      36  285711   45c0f snd-hda-intel_patched.o
> >> 
> >> This is kinda odd. Why did the _text_ size increase by constifying?
> >
> >The data got converted from data to text because they were made const.
> 
> Which is odd. How can data become code? Or does 'text' actually
> include .rodata?

More precisely: size utility adds up all readonly code and
readonly data sections it sees and shows it as "text".

ELF is not as rigid as old a.out (which had only one text, one data
and one bss segment per .o file IIRC), but size was born in a.out days,
so it sort of "translates" ELF into a.out.
--
vda
