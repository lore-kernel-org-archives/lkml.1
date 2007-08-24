Return-Path: <linux-kernel-owner+w=401wt.eu-S1765217AbXHXVov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765217AbXHXVov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbXHXVom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:44:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40831
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757261AbXHXVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:44:40 -0400
Date: Fri, 24 Aug 2007 14:44:36 -0700 (PDT)
Message-Id: <20070824.144436.59664160.davem@davemloft.net>
To: dlstevens@us.ibm.com
Cc: shemminger@linux-foundation.org, akepner@sgi.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org,
       ossthema@de.ibm.com, raisch@de.ibm.com, stefan.roscher@de.ibm.com,
       themann@de.ibm.com, tklein@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <OF0002C3DB.2E4C4A38-ON88257341.005B1253-88257341.005C7C2A@us.ibm.com>
References: <20070824085203.42f4305c@freepuppy.rosehill.hemminger.net>
	<OF0002C3DB.2E4C4A38-ON88257341.005B1253-88257341.005C7C2A@us.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Stevens <dlstevens@us.ibm.com>
Date: Fri, 24 Aug 2007 09:50:58 -0700

>         Problem is if it increases rapidly, you may drop packets
> before you notice that the ring is full in the current estimated
> interval.

This is one of many reasons why hardware interrupt mitigation
is really needed for this.
