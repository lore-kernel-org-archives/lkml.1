Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbYFSMc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbYFSMc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYFSMcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:32:19 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:48697 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbYFSMcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:32:18 -0400
Date: Thu, 19 Jun 2008 14:32:14 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: serial8250 and platform port power management
Message-ID: <20080619123214.GA21515@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

struct uart_8250_port has a pm() callback for port powermanagement.
Is there an existing way to assign this callback for a group of
8250 ports registered as platform_devices?  Looking at the source 8250.c
I actually couldn't find any users of it.

Thanks,
	Manuel Lauss


