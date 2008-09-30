Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYI3M3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYI3M3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYI3M27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:28:59 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:44119 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYI3M27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:28:59 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 08:28:58 EDT
Message-ID: <3c8f01c922f7$a032a570$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: <linux-kernel@vger.kernel.org>
Subject: How can i read really 512 byte?
Date: Tue, 30 Sep 2008 14:25:27 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

Now i am working on recover some data from one defective drive.
I am using dd_rescue, and dd, but both ready only 4K, i think, because the 
kernel's block size is 4K.

I have tried to google for the solution, but only found this trick:

losetup /dev/loop0 /dev/hdc
blockdev --setbsz 512 /dev/hdc

and after this set, trying to read the hdc...

It looks like working on the first look, but not really. :-(
The 512 size bad sectors still have 4K sizes, but the reading attempt takes 
more (8x ?) longer.

Somebody can help me to set the reading block size to 512 byte?

Thanks a lot,
Janos Haar 

