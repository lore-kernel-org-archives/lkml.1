Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbXLFLeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbXLFLeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 06:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXLFLeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 06:34:10 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:15879 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbXLFLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 06:34:08 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02NkfMqoFqI5zTcLRvR/w==
From: Stefan Rompf <stefan@loplof.de>
To: David Miller <davem@davemloft.net>
Subject: Re: sockets affected by IPsec always block (2.6.23)
Date: Thu, 6 Dec 2007 12:35:05 +0100
User-Agent: KMail/1.9.5
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200712060949.02524.stefan@loplof.de> <200712061156.48810.stefan@loplof.de> <20071206.031302.201608796.davem@davemloft.net>
In-Reply-To: <20071206.031302.201608796.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061235.06025.stefan@loplof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2007 12:13 schrieb David Miller:

> And that's why this is a grey area.  Why is waiting for memory
> allocation on a O_NONBLOCK socket OK but waiting for IPSEC route
> resolution is not?

Because you just will put enough RAM modules into you server when setting up a 
scalable system. Local resource, managable by the admin. What you cannot 
control in many cases is the network connection to the remote node. Simon 
Arlott has been talking about an 8 hour network outage.

Stefan
