Return-Path: <linux-kernel-owner+w=401wt.eu-S1765062AbXHXVrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765062AbXHXVrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbXHXVrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:47:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40841
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760445AbXHXVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:47:12 -0400
Date: Fri, 24 Aug 2007 14:47:11 -0700 (PDT)
Message-Id: <20070824.144711.18301866.davem@davemloft.net>
To: jchapman@katalix.com
Cc: shemminger@linux-foundation.org, ossthema@de.ibm.com, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <46CF127D.1090609@katalix.com>
References: <200708241747.16592.ossthema@de.ibm.com>
	<20070824085203.42f4305c@freepuppy.rosehill.hemminger.net>
	<46CF127D.1090609@katalix.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Fri, 24 Aug 2007 18:16:45 +0100

> Does hardware interrupt mitigation really interact well with NAPI?

It interacts quite excellently.

There was a long saga about this with tg3 and huge SGI numa
systems with large costs for interrupt processing, and the
fix was to do a minimal amount of interrupt mitigation and
this basically cleared up all the problems.

Someone should reference that thread _now_ before this discussion goes
too far and we repeat a lot of information and people like myself have
to stay up all night correcting the misinformation and
misunderstandings that are basically guarenteed for this topic :)
