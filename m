Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZASEZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZASEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 23:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZASEZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 23:25:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41961 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZASEZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 23:25:11 -0500
Date: Mon, 19 Jan 2009 13:25:04 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Subject: how to fix nand driver build breakage
Cc: kosaki.motohiro@jp.fujitsu.com,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <38D9F46DFF92C54980D2F2C1E8EE31301FC5E7FB@pdsmsx503.ccr.corp.intel.com>
References: <38D9F46DFF92C54980D2F2C1E8EE31301FC5E7FB@pdsmsx503.ccr.corp.intel.com>
Message-Id: <20090120132317.B0B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi all,
> 
> I have to use 64bit variable in my 2.6.27 kernel NAND driver as below:
> ---------------------------------------------------------------------------
> u64 NAND_capacity;
> unsigned int block_num, block_size;
> ...
> block_num = NAND_capacity / block_size;
> ---------------------------------------------------------------------------
> but it failed when compiling and reports 'undefined reference to `__udivdi3'.
> 
> Does any idea about this? I need to include some special head file or change something in Kconfig?
> 
> BTW, the environment is Fedora Core 9, gcc 4.3.0. 

Couldn't you use do_div()?



