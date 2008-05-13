Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYEMHZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYEMHZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYEMHZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:25:31 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:44013 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYEMHZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:25:31 -0400
Date: Tue, 13 May 2008 09:25:31 +0200
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Unallocate inodes created with new_inode()
From: BoozooK <boozook@free.fr>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ua2z8tcrpodc4a@twindruff>
User-Agent: Opera Mail/9.50 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm currently writing a simple read-only filesystem based on a device. I  
use the new_inode function (which is defined in inode.c) to allocate my  
inodes and my driver holds a list of the allocated inodes in order to  
destroy them in the end, but I don't know how I should destroy them (I  
mean with which function). I currently get a "Busy inodes after unmount"  
message after unmounting my filesystem.

Thanks in advance,
BoozooK.
