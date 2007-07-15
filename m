Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbXGOG54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbXGOG54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 02:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXGOG5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 02:57:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55404
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbXGOG5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 02:57:46 -0400
Date: Sat, 14 Jul 2007 23:57:48 -0700 (PDT)
Message-Id: <20070714.235748.02297780.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [RFC 0/3] lro: Generic Large Receive Offload for TCP traffic
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707111621.24852.ossthema@de.ibm.com>
References: <200707111621.24852.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I think this work is great.  Thanks for doing it.

Besides the fixups Evgeniy has selected, and the suggestion
to receive into pages to cut down allocation costs, my
only request is to make this thing able to handle ipv6 as
well even if no current chips could facilitate that yet.
