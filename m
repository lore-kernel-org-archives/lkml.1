Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbXLMUiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbXLMUiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761793AbXLMUil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:38:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57385
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbXLMUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:38:41 -0500
Date: Thu, 13 Dec 2007 12:38:40 -0800 (PST)
Message-Id: <20071213.123840.241818979.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: gallatin@myri.com, joonwpark81@gmail.com, auke-jan.h.kok@intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <4761896B.7070801@linux-foundation.org>
References: <476181C1.3060204@myri.com>
	<20071213.110928.26060224.davem@davemloft.net>
	<4761896B.7070801@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Thu, 13 Dec 2007 11:35:07 -0800

> How about allowing a return value of -1 from napi_poll and letting
> device check itself.

It doesn't avoid the code duplication in the ->poll() fast paths.

I don't care, on the other hand, if crap accumulates in non-critical
slow paths like napi_disable() and dev_close().  That's why I'm
suggesting solutions in that area.
