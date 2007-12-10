Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXLJTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXLJTTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXLJTTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:19:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:29452 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXLJTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:19:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gbo7nMhEyyfDShzbObEqzDXcQ27WngeIvdFmnyqyHok8AHWE7tSjLToyvgvn/ftxRxcncaBraoqD8Ove+2V3fUfvza08ZaQv8nxun3eR11SKq9tFGXVSjHDpNWWzSIPnGpJ0oTvdT+RS/jvX0VvBvkXapc0/o0kljJ4h72Kf4xQ=
Message-ID: <475D9130.6070401@gmail.com>
Date: Mon, 10 Dec 2007 20:19:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/sysfs/file.c: use DEFINE_SPINLOCK for	sysfs_open_dirent_lock
 definition
References: <20071210190323.GB20186@traven>
In-Reply-To: <20071210190323.GB20186@traven>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2007 08:03 PM, Matthias Kaehlcke wrote:
> fs/sysfs/file.c: use DEFINE_SPINLOCK for definition of
> sysfs_open_dirent_lock instead of assigning SPIN_LOCK_UNLOCKED

Already done:
http://lkml.org/lkml/2007/11/9/222

regards,
--js
