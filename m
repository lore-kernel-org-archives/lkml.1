Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbZCJX4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbZCJX4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZCJX4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:56:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53736 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750886AbZCJX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:56:38 -0400
Date: Tue, 10 Mar 2009 23:56:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "Altobelli, David" <david.altobelli@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tweak spin logic for hpilo
Message-ID: <20090310235659.1fe62b2e@lxorguk.ukuu.org.uk>
In-Reply-To: <49B6F9A9.1030803@gmail.com>
References: <20090309225651.GA13702@ldl.fc.hp.com>
	<20090309160437.b71041d5.akpm@linux-foundation.org>
	<92D64232F2316045B18937D5C9996B1522834ABED6@GVW1144EXB.americas.hpqcorp.net>
	<49B6F9A9.1030803@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You're using udelay, which is a spin loop. Nothing else can happen on 
> that CPU while it's delaying anyway.

However if your polling is doing I/O its clogging up the I/O busses (and
quite often the bridge)
