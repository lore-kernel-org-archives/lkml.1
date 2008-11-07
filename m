Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYKGLXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYKGLXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYKGLW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:22:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:21415 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYKGLWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hclLE5AApjG4DlSi7tItKRy56feRIHgVL2tFslW+BnF8nOd61HbjExKbZINQJSi2TQ
         rKW7lMclIVWl/93bPMS+C/mcrBdW59S/q5Md/ac3ylH6ygo17avoVdv1GBgJj0CdyO77
         zbeeasN/xSDFq+AE7BcwMvQZibz0yv/NrpVrE=
Date: Fri, 7 Nov 2008 12:22:50 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Buddhike De Silva <buddhike.desilva@readify.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Compiling a small kernel on Ubuntu
Message-ID: <20081107122250.31884d61@varda>
In-Reply-To: <B635664A870E3E409144F6DDD84ABA3C3842945EE2@rpmail01.solar.system>
References: <B635664A870E3E409144F6DDD84ABA3C3842945EE2@rpmail01.solar.system>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 7 Nov 2008 16:15:36 +1100
Buddhike De Silva <buddhike.desilva@readify.net> escribió:

> Hi Everyone,
> 
> I'm trying to learn how linux scheduler is implemented. As a result, I wanted to compile and run linux kernel from its source code. That way I can assure that I have a working base to play around. I started by following this article:
> http://www.digitalhermit.com/linux/Kernel-Build-HOWTO.html
> 
> I managed to complete the given instructions and change Grub to display a new entry to select the newly compiled kernel. However, it falls over while trying to load (unable to handle kernel paging request). My gut feeling says I've missed something in the kernel configuration step. Can someone please tell me the basic set of options required for a kernel to get the following system up and running?

 Why not base your config in the ubuntu config? 
 cp /boot/config-$(uname -r) path/to/kernelsource
 make oldconfig
 (answer some questions)

> 
> Machine: IBM thinkpad t42
> CPU:  Intel Centrino Mobile 32bit
> RAM: 1 GB
> Hard Disk: 40GB IDE
> 
> Also is there a guide for kernel debugging? Thanks a lot in advance.
> 
> Cheers,
> Buddhike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
