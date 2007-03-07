Return-Path: <linux-kernel-owner+w=401wt.eu-S2992706AbXCGWnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992706AbXCGWnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992710AbXCGWmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:42:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48635
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992717AbXCGWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:42:49 -0500
Date: Wed, 07 Mar 2007 14:42:48 -0800 (PST)
Message-Id: <20070307.144248.48528321.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, auke@foo-projects.org,
       john.ronciak@intel.com
Subject: Re: [PATCH 1/2] NET: Multiple queue network device support
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329026B6719@orsmsx414.amr.corp.intel.com>
References: <20070226.170317.41636240.davem@davemloft.net>
	<D5C1322C3E673F459512FB59E0DDC329026B6719@orsmsx414.amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I didn't say to use skb->priority, I said to shrink skb->priority down
to a u16 and then make another u16 which will store your queue mapping
value.

