Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZK3BJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZK3BJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 20:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZK3BJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 20:09:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51759
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbZK3BJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 20:09:38 -0500
Date: Sun, 29 Nov 2009 17:09:43 -0800 (PST)
Message-Id: <20091129.170943.261866677.davem@davemloft.net>
To: pboettcher@kernellabs.com
Cc: linux-kernel@vger.kernel.org, errandir_news@mph.eclipse.co.uk
Subject: Re: PATCH [0/2] - CHECKSTACK: sparc-stack-size and formatting
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
References: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Boettcher <pboettcher@kernellabs.com>
Date: Mon, 23 Nov 2009 12:01:00 +0100 (CET)

> I shamelessly stole the checkstack-script for a project of mine and
> now want to contribute what I changed:
> 
> 1) CHECKSTACK: sparc: fix regex to match all stacksizes
> 2) CHECKSTACK: simplify text-formatting for displaying the stacksize
> 
> For 1): as there are no comments in the script as to why the regex was
> limiting the detection of stacksizes to less 300 bytes and if I
> understood it correctly, to a maximum of 1000, I simply removed it.

The limit is just an oversight as far as I can tell, your sparc
regex fix looks fine to me, thanks!

Acked-by: David S. Miller <davem@davemloft.net>
