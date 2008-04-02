Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYDBQ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYDBQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbYDBQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:59:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:60219 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbYDBQ7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,594,1199692800"; 
   d="scan'208";a="266582061"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-rc8-mm1
Date: Wed, 2 Apr 2008 09:58:46 -0700
Message-ID: <D936D925018D154694D8A362EEB089200415A690@orsmsx416.amr.corp.intel.com>
In-Reply-To: <a44ae5cd0804020349v695e22b6k3c273a5724c5d52e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-rc8-mm1
thread-index: AciUr1DXG/NSP3+9Rq2NePqt9cr+jwAMM94A
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <a44ae5cd0804020349v695e22b6k3c273a5724c5d52e@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Miles Lane" <miles.lane@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <ipw3945-devel@lists.sourceforge.net>, "Zhu, Yi" <yi.zhu@intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
X-OriginalArrivalTime: 02 Apr 2008 16:58:48.0070 (UTC) FILETIME=[D1A30260:01C894E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 02, 2008 3:49 AM, Miles Lane  wrote:

>  CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> 'iwl3945_build_tx_cmd_basic':
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2492: error: 'struct
> iwl3945_priv' has no member named 'rxtxpackets' 
> make[4]: *** [drivers/net/wireless/iwlwifi/iwl3945-base.o] Error 1
> 

Thanks! John Linville just posted a fix for this problem to
wireless-testing ("drivers/net/wireless/iwlwifi/iwl-3945.h: correct
CONFIG_IWL4965_LEDS typo")

Reinette
