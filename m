Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYJUUNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYJUUNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJUUN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:13:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:38873 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYJUUN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:13:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,460,1220252400"; 
   d="scan'208";a="453978409"
Subject: Re: iwl3945: if I leave my machine running overnight, wifi will
	not work in the morning
From: reinette chatre <reinette.chatre@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "jbenc@suse.cz" <jbenc@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       "i.zhu@intel.com" <i.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20081019214035.GA30485@elf.ucw.cz>
References: <20081019214035.GA30485@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 13:13:45 -0700
Message-Id: <1224620025.10863.50.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 14:40 -0700, Pavel Machek wrote:

> root@amd:~# ping hobit
> PING hobit.ucw.cz (10.0.0.2): 56 data bytes
> ^C
> --- hobit.ucw.cz ping statistics ---
> 34 packets transmitted, 0 packets received, 100% packet loss
> root@amd:~#

Can we start to get some debug logs about what happens when you try to
ping (and it fails)? Please ensure driver is compiled with debugging
(CONFIG_IWL3945_DEBUG) and load the module with debug=0x43fff

Also, please submit a bug for this
( http://www.intellinuxwireless.org/bugzilla/ )to help us keep track of
all the debugging output you are providing.

Thank you

Reinette

