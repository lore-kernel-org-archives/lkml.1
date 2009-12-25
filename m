Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZLYU4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZLYU4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 15:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZLYU4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 15:56:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60132 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbZLYU4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 15:56:19 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Regression in module wmi since 2.6.32 (bisected to commit 1caab3c)
Date: Fri, 25 Dec 2009 20:56:08 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.31.5; KDE/4.3.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
References: <4B352513.90302@lwfinger.net>
In-Reply-To: <4B352513.90302@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912252056.08436.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 December 2009 20:48:19 Larry Finger wrote:
> If I modprobe wmi after the system is booted, the specific messages are as
>  follows:
> 
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:477 sysfs_add_one+0xd6/0xee()
> Hardware name: System Product Name
> sysfs: cannot create duplicate filename
> '/devices/virtual/wmi/05901221-D566-11D1-B2F0-00A0C9062910'

Interesting - what hardware is this? And can you post the DSDT?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
