Return-Path: <linux-kernel-owner+w=401wt.eu-S964983AbXCFNwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbXCFNwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965024AbXCFNwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:52:41 -0500
Received: from twin.jikos.cz ([213.151.79.26]:59834 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbXCFNwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:52:40 -0500
Date: Tue, 6 Mar 2007 14:52:38 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Mockern <Mockern@yandex.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question: shutdown Linux from user space
In-Reply-To: <45ED6973.000007.21430@webmail11.yandex.ru>
Message-ID: <Pine.LNX.4.64.0703061451480.10909@twin.jikos.cz>
References: <45ED6973.000007.21430@webmail11.yandex.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Mockern wrote:

> I need to shutdown Linux from user level application. Which is the best 
> way to do it? (I need it for embedded system)

Use sys_reboot() syscall with either LINUX_REBOOT_CMD_HALT or 
LINUX_REBOOT_CMD_POWER_OFF.

Also this is probably offtopic here, please use kernelnewbies mailinglist 
instead.

-- 
Jiri Kosina
