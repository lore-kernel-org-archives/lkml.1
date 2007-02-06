Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXBFSk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXBFSk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXBFSk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:40:27 -0500
Received: from za-gw.sanpeople.com ([196.211.225.226]:2430 "EHLO
	za-gw.sanpeople.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbXBFSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:40:26 -0500
X-Greylist: delayed 1759 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 13:40:26 EST
Subject: Re: [PATCH] atmel_serial: Use __raw I/O register access
From: Andrew Victor <andrew@sanpeople.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070206181612.3002449a@dhcp-252-105.norway.atmel.com>
References: <20070206181612.3002449a@dhcp-252-105.norway.atmel.com>
Content-Type: text/plain
Organization: Multenet Technologies (Pty) Ltd
Message-Id: <1170784791.873.80.camel@fuzzie.sanpeople.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 
Date: 06 Feb 2007 19:59:52 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Access to chip-internal registers should always be native-endian.
> This is especially important for AVR32 since it's a big-endian
> architecture and the non-raw readl() and writel() macros are defined
> to do little-endian accesses.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Acked-by: Andrew Victor <andrew@sanpeople.com>



