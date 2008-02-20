Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbYBTVuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbYBTVuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbYBTVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:49:51 -0500
Received: from senator.holtmann.net ([87.106.208.187]:35998 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079AbYBTVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:49:50 -0500
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh <greg@kroah.com>,
       akpm <akpm@linux-foundation.org>
Message-Id: <6196E805-23A7-47EA-813C-1FDDEA8949FC@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080220132100.c168fc20.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 2/2] firmware: fix a few build errors
Date: Wed, 20 Feb 2008 22:49:48 +0100
References: <20080220132100.c168fc20.randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> Fix one typo (comma to semi-colon).
> Fix sysfs externs (just use sysfs.h for prototypes).
>
> Documentation/firmware_class/firmware_sample_firmware_class.c:37:  
> error: conflicting types for 'sysfs_remove_bin_file'
> include/linux/sysfs.h:100: error: previous declaration of  
> 'sysfs_remove_bin_file' was here
>
> Still has a build error:
> ERROR: "firmware_class" [samples/firmware_class/ 
> firmware_sample_firmware_class.ko]
> undefined!

while you are at it, can you also fix the broken coding style in it?

Regards

Marcel

