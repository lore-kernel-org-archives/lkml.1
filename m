Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbYDBRzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbYDBRzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbYDBRy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:54:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:27664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbYDBRy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:54:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,594,1199692800"; 
   d="scan'208";a="364880701"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-rc8-mm1 -- drivers/net/wireless/iwlwifi/iwl-led.c:184: error: 'struct iwl_priv' has no member named 'last_blink_time'
Date: Wed, 2 Apr 2008 10:52:14 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004194769@orsmsx416.amr.corp.intel.com>
In-Reply-To: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-rc8-mm1 -- drivers/net/wireless/iwlwifi/iwl-led.c:184: error: 'struct iwl_priv' has no member named 'last_blink_time'
thread-index: AciUsXxnai/zzZrjQQaoAGfpdBfcuwAOJaiQ
References: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Miles Lane" <miles.lane@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, "Zhu, Yi" <yi.zhu@intel.com>,
       "wireless" <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
X-OriginalArrivalTime: 02 Apr 2008 17:52:18.0517 (UTC) FILETIME=[4B365850:01C894EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 02, 2008 4:04 AM, Miles Lane  wrote:

>  CC [M]  drivers/net/wireless/iwlwifi/iwl-led.o
> drivers/net/wireless/iwlwifi/iwl-led.c: In function
> 'iwl4965_led_associated': drivers/net/wireless/iwlwifi/iwl-led.c:184:
> error: 'struct iwl_priv' has no member named 'last_blink_time'
> drivers/net/wireless/iwlwifi/iwl-led.c:184: error: 'struct iwl_priv'
> has no member named 'allow_blinking'
> drivers/net/wireless/iwlwifi/iwl-led.c:185: error: 'struct iwl_priv'
> has no member named 'last_blink_time'
> drivers/net/wireless/iwlwifi/iwl-led.c: In function
> 'iwl4965_led_brightness_set':

Another problem with iwlwifi config variables. A fix has just been sent
to wireless-testing ("iwl4965: use IWLWIFI_LEDS config variable").

Thanks!

Reinette
