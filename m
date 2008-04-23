Return-Path: <linux-kernel-owner+w=401wt.eu-S933525AbYDWCKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbYDWCKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYDWCJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:09:57 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:11813 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYDWCJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:09:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bLu25NGI3J6rva1NyNyNwjdrLXKRZHMKGA8mk35CGzigY0qBmt5ZU/OIV8auylOVycnzzBV+P2IgJlOYhuM7wM9A7+KMk9l4A+TCKNle+VuyvohFVk0RYkrNUPERg1LbEG2Xg/hndd4MMb8BzPvVDp8WJdRI5uiLfwH6+o+4z94=
Message-ID: <480E9A69.4070503@gmail.com>
Date: Wed, 23 Apr 2008 11:09:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dan McGee <dpmcgee@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata_piix: add Asus Eee 701 controller to short cable
 list
References: <1208747007-9791-1-git-send-email-dpmcgee@gmail.com>
In-Reply-To: <1208747007-9791-1-git-send-email-dpmcgee@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan McGee wrote:
> The drive is directly soldered to the controller, so there is no cable at
> all. Remove the 40-wire assumption so the drive can operate at max speed.
> 
> Before patch:
> $ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
> 134217728 bytes (134 MB) copied, 5.29612 s, 25.3 MB/s
> 
> After patch:
> $ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
> 134217728 bytes (134 MB) copied, 3.94955 s, 34.0 MB/s
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
