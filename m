Return-Path: <linux-kernel-owner+w=401wt.eu-S1764834AbXHXVn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764834AbXHXVn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbXHXVnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:43:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44114
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758017AbXHXVnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:43:46 -0400
Date: Fri, 24 Aug 2007 14:43:43 -0700 (PDT)
Message-Id: <20070824.144343.95051903.davem@davemloft.net>
To: linas@austin.ibm.com
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, tklein@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, raisch@de.ibm.com, meder@de.ibm.com,
       stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070824164541.GG4282@austin.ibm.com>
References: <200708241559.17055.ossthema@de.ibm.com>
	<20070824164541.GG4282@austin.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: linas@austin.ibm.com (Linas Vepstas)
Date: Fri, 24 Aug 2007 11:45:41 -0500

> In the end, I just let it be, and let the system work as a
> busy-beaver, with the high interrupt rate. Is this a wise thing to
> do?

The tradeoff is always going to be latency vs. throughput.

A sane default should defer enough to catch multiple packets coming in
at something close to line rate, but not so much that latency unduly
suffers.
