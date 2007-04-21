Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXDUPLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXDUPLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXDUPLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:11:13 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:3952 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbXDUPLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SOY58M2dkAxlMbLPvqTWn/bSOVS54p7NLvR3MlQC1APqX5XfhLUoy+3/wq6oSZ+b+99w0StSphhTBlhA5vVC01RGwy/ZuNA1AKyHDr5WLZlRMOFcVKCElZIpPbA2+mAvz/H9ftt66hTtsnhvirRNPjraTQCHg1tkf8mN/STZXTY=
Message-ID: <b637ec0b0704210811t3815ebb9y6f601637e5b21571@mail.gmail.com>
Date: Sat, 21 Apr 2007 17:11:10 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: "Chuck Ebbert" <cebbert@redhat.com>, Stephen.Clark@seclark.us,
       "Mark Lord" <liml@rtr.ca>, "Tejun Heo" <htejun@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       emisca <emisca.ml@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       "Adrian Bunk" <bunk@stusta.de>, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.61.0704211631540.9989@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <88SeR-5Sf-15@gated-at.bofh.it>
	 <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca>
	 <46263859.2060309@gmail.com> <46265089.4000409@rtr.ca>
	 <46265307.7060405@rtr.ca> <4626596E.4040304@seclark.us>
	 <4627ABE9.8090906@redhat.com>
	 <b637ec0b0704201257l24d9e9c8ha31221c9c9d8da3e@mail.gmail.com>
	 <Pine.LNX.4.61.0704211631540.9989@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,
mine does not pop running Linux but  only during the shutdown. As I
wrote before, switching from PATA to IDE has solved the problem for
me.
Regards,
Fabio


On 4/21/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> >On Apr 20 2007 21:57, Fabio Comolli wrote:
> >
> > hda: TOSHIBA MK8025GAS, ATA DISK drive
>
> MK...? These sort of disks do that stupid pop. Mine -- a MK2003GAH --
> does it even while running Linux, if the disk is _idle_.
> See http://lkml.org/lkml/2006/11/15/413 - hope it provides some pointers.
>
> Regards,
> Jan
> --
>
