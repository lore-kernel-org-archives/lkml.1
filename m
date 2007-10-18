Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbXJRRue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbXJRRue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759728AbXJRRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:50:26 -0400
Received: from smtp.nokia.com ([131.228.20.170]:60504 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbXJRRuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:50:25 -0400
Message-ID: <47179CAE.6010806@yandex.ru>
Date: Thu, 18 Oct 2007 20:49:34 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: is the inode an orphan?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Oct 2007 17:49:34.0940 (UTC) FILETIME=[3EBA39C0:01C811AF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need a help from VFS folks: when I'm in ->unlink() in is there a safe way to 
to realize that ->delete_inod()e is going to be called? IOW, I'd like to call 
myfs_delete_inode() myself form ->unlink(), and not wait for VFS calling 
->delete_inode().

Or to put it differently, I'd like to know if the inode is an orphan or not in 
->unlink()?

AFAICS, if (inode->i_nlink == 0 && atomic_read(&inode->i_count) == 2) then this 
  file is not going to be an orphan. And AFAIC judge, it is safe to use this, 
but I'm not sure and kindly ask for help.

Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
