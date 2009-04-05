Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZDEXMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZDEXMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZDEXM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:12:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46287 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbZDEXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:12:27 -0400
Date: Mon, 6 Apr 2009 01:14:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
Message-ID: <20090405231425.GC17934@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Something between 2.6.29 and 2.6.29-git12 broke vga=0x0f07 text mode
on one of my test boxes. The text mode display is still (barely)visible, 
but the display contents continuous move over the screen horizontally while
flickering. Without the option in 80x25 mode it still works. 2.6.29
also works fine.

This is a MSI system with integrated Intel GPU.

00:02.1 Display controller: Intel Corporation: Unknown device 29c3 (rev 02)

Please tell me if you need more information, i'm not sure
what I should collect.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
