Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbZDSAX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbZDSAX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 20:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZDSAXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 20:23:48 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:38806 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZDSAXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 20:23:48 -0400
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 8BIT
Message-Id: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Quick question about libata and hdparm
Date: Sat, 18 Apr 2009 21:22:11 -0300
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear people,

I have one small question regarding the libata drivers and the  
interaction with hdparm.

I am presently using PATA/IDE devices only, but some distributions  
provide kernels with libata by default (and some defconfigs also use  
libata even for IDE devices).

Using the usual IDE drivers, I can use/query various parameters with  
hdparm, like, for instance, the -m option, the -c option or even  
disabling DMA. With the libata drivers, this is all that I get:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
lutz:~# hdparm /dev/sda

/dev/sda:
  IO_support    =  0 (default)
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 48641/255/63, sectors = 781420655, start = 0
lutz:~# hdparm -c 1 /dev/sda

/dev/sda:
  setting 32-bit IO_support flag to 1
  HDIO_SET_32BIT failed: Invalid argument
  IO_support    =  0 (default)
lutz:~# hdparm -m 16 /dev/sda

/dev/sda:
  setting multcount to 16
  HDIO_SET_MULTCOUNT failed: Inappropriate ioctl for device
  HDIO_GET_MULTCOUNT failed: Inappropriate ioctl for device
lutz:~#
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Am I doing something incorrectly? I would like at least to understand  
what is happening and, if possible, to fine-tune some settings.

If necessary, please let me know and I will provide any further  
information that may be needed.


Thanks in advance, Rogério Brito.

