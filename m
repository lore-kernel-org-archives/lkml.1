Return-Path: <linux-kernel-owner+w=401wt.eu-S1761184AbYDKUuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbYDKUuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbYDKUt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:49:56 -0400
Received: from mga06.intel.com ([134.134.136.21]:28550 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759196AbYDKUtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:49:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,643,1199692800"; 
   d="scan'208";a="370267136"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Date: Fri, 11 Apr 2008 13:44:08 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-7-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1207946244-14525-7-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804111344.09226.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> Unfortunately, instead of adding a generic Wireless WAN type, a technology-
> specific type (WiMAX) was added.  That's useless for other WWAN devices,
> such as EDGE, UMTS, X-RTT and other such radios.
> 
> Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> as most devices use KEY_RADIO for WWAN control and need no specific keycode
> added.

I know it is easier to complain than to submit code, but at this
point, shouldn't we make this dynamic? [so that the interested technology
that provides an rfkill switch registers it?].

Something that given a technology name registers a dynamic key and type
number that can be use throughout?
	
-- 
Inaky
