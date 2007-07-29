Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbXG2I5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbXG2I5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 04:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760665AbXG2I45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 04:56:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39024
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760651AbXG2I44 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 04:56:56 -0400
Date: Sun, 29 Jul 2007 01:56:56 -0700 (PDT)
Message-Id: <20070729.015656.41635835.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: w@1wt.eu, darryl-mailinglists@netbauds.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: TCP SACK issue, hung connection, tcpdump included
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707291052300.10340@kivilampi-30.cs.helsinki.fi>
References: <46AC2CBE.5010500@netbauds.net>
	<20070729064511.GA18718@1wt.eu>
	<Pine.LNX.4.64.0707291052300.10340@kivilampi-30.cs.helsinki.fi>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Sun, 29 Jul 2007 11:26:00 +0300 (EEST)

> Is this reproducable? Can you somehow verify that the packets CLIENT is 
> sending are indeed received by the SERVER...?

One possibility is drops due to checksum errors on the receiver, this
tends to pop up from time to time, let's see some SNMP statistics.
