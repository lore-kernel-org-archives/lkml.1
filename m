Return-Path: <linux-kernel-owner+w=401wt.eu-S933091AbZLNV2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091AbZLNV2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932827AbZLNV2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:28:21 -0500
Received: from host013.keli.cz ([77.48.235.13]:50969 "EHLO host013.keli.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbZLNV2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:28:20 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 16:28:20 EST
Message-ID: <4B26AB7E.9020208@titera.eu>
Date: Mon, 14 Dec 2009 22:17:50 +0100
From: =?ISO-8859-2?Q?Petr_Tit=ECra?= <petr@titera.eu>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Wrong atime on recent kernels
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

       I see some strange file modification times recently. It seems to 
me that in some situations, kernel allows to set nanoseconds part of  
file access, modification or change time  to 100000000 ns. Problem seems 
to be in some generic part of kernel because I see it on several 
different filesysytems (ext4 and nilf2). These is I've got during my 
testing on kernel  2.6.32-tip-08309-gad8e75a.

  File: `./Documentation/dvb/contributors.txt'
  Size: 3035            Blocks: 8          IO Block: 4096   regular file
Device: fe04h/65028d    Inode: 818         Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-12-14 10:29:04.1000000000 +0100
Modify: 2009-12-14 10:29:04.1000000000 +0100
Change: 2009-12-14 10:29:04.1000000000 +0100

See that all times of that file ends with 1e6 nanoseconds.

Petr Titera
