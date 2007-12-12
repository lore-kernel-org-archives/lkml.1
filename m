Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXLLLom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXLLLom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbXLLLoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:44:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:46208 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbXLLLod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:44:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KW0tEjH37G5Jy3Avsc3nhs6PbAJhGMYn7EvMXY/OwDfb16w7Fhlbj5dpg4e8AvPmhzfjFkzkIHKjoIK77t7AmGc7AICJPioKYWSEK4ArK2JXzc7BRCVjFV+zvHjnRwIC77D2O80nj6xE16iIXCVuXOLILcfhvV1n7e003iJ8gwk=
Date: Wed, 12 Dec 2007 12:43:34 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212124334.47377fed@Varda>
In-Reply-To: <475F2846.1010402@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
	<20071212004316.079e3a05@Varda>
	<475F227D.7050203@keyaccess.nl>
	<20071212010928.3c763ccd@Varda>
	<475F2846.1010402@keyaccess.nl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 12 Dec 2007 01:16:06 +0100
Rene Herman <rene.herman@gmail.com> escribió:

> On 12-12-07 01:09, Alejandro Riveira Fernández wrote:

[...]

> 
> Great, thanks much for reporting. Sort of interesting in itself that without 
> -O2 you do still get correct results on 64-bit but for some other time.
> 
> You're the first one to go significantly below 1 us it seems.

 :( I have seen the other msg and i have to say that the tests where done at
1GHz not at full speed. At full speed i see
 
 cycles: out 3025, in 1653
 cycles: out 3040, in 1708
 cycles: out 3044, in 1650
 cycles: out 3034, in 1652
 cycles: out 3035, in 1652
 cycles: out 3037, in 1652
 cycles: out 3043, in 1709
 cycles: out 3032, in 1648
 cycles: out 3039, in 1652
 cycles: out 3041, in 1652
 cycles: out 3048, in 1704
 cycles: out 3040, in 1650
 cycles: out 3023, in 1631
 cycles: out 3036, in 1652
 cycles: out 3042, in 1706
 cycles: out 3047, in 1708
 cycles: out 3047, in 1711
 cycles: out 3036, in 1652


 

> 
> Rene.
