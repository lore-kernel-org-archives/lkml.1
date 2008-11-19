Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYKSJB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYKSJB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYKSJBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:01:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:7854 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYKSJBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=IlebSlD+VeuKUT9fd23P2BfwIkAkoMQNetPMSwGr4wVWbUvPM7jTU57+xkp3yWWtVE
         TTNBId2TfHy6ZWe58stmRyqAM5HVPcLsKgVHNqfzh9yTTGkuV/JXPIB8ebWKtiFvfqyA
         53kDOGBunzuh93d1bkj/WKDgKZtPpxmAVOZVI=
Message-ID: <eb0b59820811190101i50a18bd6m39bd8313d5b31dd4@mail.gmail.com>
Date: Wed, 19 Nov 2008 11:01:18 +0200
From: "=?UTF-8?B?0KHQtdGA0LPRltC5INCh0YLQtdGG0YzQutC+0LLQuNGH?=" 
	<patriotyk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Data corruption in some BIOSes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am working on some project where I need to boot winxp from linux,
and I am using kexec for it, but in some computers it doesn't work.
When kexec jumps to my kernel, in kernel  I am switching to real mode
and try to call int13h to read mbr sector. But I have one
computer(with AMI BIOS and this computer is newer than others) where
this BIOS call doesn't work.
I think it is the problem with data corruption of BIOS memory, and I
also have compiled 2.6.27.6 kernel(where is applied patch
X86_RESERVE_LOW_64K), but it didn't help.
I think maybe I'm doing something wrong, maybe I need to do restoring
reserved BIOS memory in kexec kernel function before loading new
kernel?

Please help me!

Thanks, Serhiy
