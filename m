Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZASCw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZASCw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbZASCws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:52:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:37426 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113AbZASCwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:52:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,285,1231142400"; 
   d="scan'208";a="379516129"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 10:54:02 +0800
Subject: 
Thread-Index: Acl54S8WAR/0PuuAQAyOqrCYBnRpxA==
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE31301FC5E7FB@pdsmsx503.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have to use 64bit variable in my 2.6.27 kernel NAND driver as below:
---------------------------------------------------------------------------
u64 NAND_capacity;
unsigned int block_num, block_size;
...
block_num = NAND_capacity / block_size;
---------------------------------------------------------------------------
but it failed when compiling and reports 'undefined reference to `__udivdi3'.

Does any idea about this? I need to include some special head file or change something in Kconfig?

BTW, the environment is Fedora Core 9, gcc 4.3.0. 

Thanks a lot.

Rgds,
Yunpeng Gao


