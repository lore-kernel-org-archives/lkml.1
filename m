Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYLOHIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYLOHIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 02:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYLOHIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 02:08:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:37053 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbYLOHH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 02:07:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,222,1228118400"; 
   d="scan'208";a="90193802"
From: "Shi, Alex" <alex.shi@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2008 15:07:17 +0800
Subject: is it a timer bug? 
Thread-Topic: is it a timer bug? 
Thread-Index: Acleg8PGF8SOgbyDTxeUPOdlntIjQQ==
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA6501C51D1271@PDSMSX501.ccr.corp.intel.com>
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

I notice the timer interrupts is quit high on the 2.6.28-rc8 kernel in my Nehalem machine. 
A, 180+/second timer interrupts in my Nehalem machine with tickless enable. 
B, the timer interrupts reduce to 10-/second with tickless and highres enable. 
On 2.6.27 kernel, the timer interrupts can keep low with tickless kernel whenever the highres feature is enable or not. 
So it is timer bug on my machine? 

Brgs
Alex 
