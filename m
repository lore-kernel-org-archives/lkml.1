Return-Path: <linux-kernel-owner+w=401wt.eu-S1161053AbXDCSfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053AbXDCSfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161103AbXDCSfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:35:33 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:19497 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161053AbXDCSfc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:35:32 -0400
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning: unable to open an initial console.
Date: Tue, 3 Apr 2007 11:35:25 -0700
In-Reply-To: <a8e1da0704021834q7911fb56oa0f3f23651ee6be2@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning: unable to open an initial console.
Thread-Index: Acd1kDaWk9V9n23CSQ+YMUSARRzbUgAihwTA
References: <20070402190458.0EDD039005F@mail42-fra.bigfish.com> <20070402224923.GA11208@tuatara.stupidest.org> <20070402232012.6716E64781D@mail78-cpk.bigfish.com> <a8e1da0704021834q7911fb56oa0f3f23651ee6be2@mail.gmail.com>
From: "Tom Strader" <tom.strader@xilinx.com>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Apr 2007 18:35:26.0101 (UTC) FILETIME=[D8C19450:01C7761E]
Message-Id: <20070403183532.0EE676CC6F2@mail138-cpk.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
I'm not sure if I follow.  How do I use mknod with no console to use it
from?  Can this be done in the init scripts or from u-boot?  Still
learning so any help would be appreciated.

I was able to trace the console opening to __dentry_open() in fs/open.c
It does open(inode, f) but returns error -6 if this is any help.  I will
try to trace it further to see what is wrong.

Thanks,
Tom




