Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXIEPSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXIEPSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXIEPR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:17:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58575 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXIEPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:17:56 -0400
Date: Wed, 5 Sep 2007 17:17:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
cc: noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rescanning SCSI/SATA bus
In-Reply-To: <20070905151536.GA13021@atjola.homenet>
Message-ID: <Pine.LNX.4.64.0709051716510.5419@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709051140130.5419@fbirervta.pbzchgretzou.qr>
 <yq1zm01l0co.fsf@sermon.lab.mkp.net> <d00698fb0709050704j1014b87al20cfb451ac609e81@mail.gmail.com>
 <20070905142600.GA12798@atjola.homenet> <d00698fb0709050745p820f0ednf6592b142d1e409c@mail.gmail.com>
 <20070905151536.GA13021@atjola.homenet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5 2007 17:15, Björn Steinbrink wrote:
>> > > > Jan> 11:40 sun:../scsi_host/host0 # echo 1 >scan
>> > > > Jan> -bash: echo: write error: Invalid argument
>> > > >
>> > > > echo "- - -" > scan
>> >
>> > Note the spaces between the dashes.
>> 
>> Thanks. Unfortunately it produced the same error.
>> Is rescanning even supported with the sata_nv driver?
>
>Works just fine here:
>root@atjola:/sys/class/scsi_host/host0# echo - - - > scan 
>root@atjola:/sys/class/scsi_host/host0# cat proc_name 
>sata_nv

FWIW, silently does nothing for sym53c8xx. For sata_nv, prints
something in dmesg.


	Jan
-- 
