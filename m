Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYDHTEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYDHTEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbYDHTEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:04:12 -0400
Received: from mail.vyatta.com ([216.93.170.194]:40201 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbYDHTEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:04:11 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.222
Date: Tue, 8 Apr 2008 14:04:03 -0500
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: wimax@linuxwimax.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Message-ID: <20080408140403.3e7191bb@speedy>
In-Reply-To: <200804011107.38563.inaky@linux.intel.com>
References: <200804011107.38563.inaky@linux.intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the kernel/user interface: wimax-tools-1.1/lib/op-open.c

This API is repeating the mistake of the old Linux Wireless API. It is putting version
checks between kernel and library and this is a maintenance nightmare. Linux
API's are not COM. Versioning is a mistake.  Use a TLA api like netlink so it
can be extensible without version handshake.
