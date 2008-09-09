Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYIIJ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYIIJ1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbYIIJ1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:27:02 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:10075 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbYIIJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Xl29fLl9Ob1FC6Ye6ZYHAKtDIrnOfenygaF7SJZOArHyPs+blj+epzdqwTp5IkfyYT
         Vjs3hRSxrbgSM53Topa+lih8kXTEtIbesYC+iE+n5oKx9iSST7SAG4u+RKFXtnjiCiPR
         cRSIZC2umVSfMW6EONTc1RrAvcktq5FKl7eAU=
Message-ID: <48C6415B.3050209@gmail.com>
Date: Tue, 09 Sep 2008 11:26:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mchehab@infradead.org, video4linux-list@redhat.com
Subject: undefined reference to `v4l_printk_ioctl' [Was: mmotm 2008-09-08-18-32
 uploaded]
References: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
In-Reply-To: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napsal(a):
> The mm-of-the-moment snapshot 2008-09-08-18-32 has been uploaded to

Hi,

CONFIG_VIDEO_DEV=m
CONFIG_COMPAT_VIDEO_DEV=y

causes:
drivers/built-in.o: In function `v4l_compat_ioctl32':
(.text+0x8db19): undefined reference to `v4l_printk_ioctl'

COMPAT_VIDEO_DEV should be tristate?
