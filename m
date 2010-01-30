Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869Ab0A3Eiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0A3Eiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 23:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288Ab0A3Eip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 23:38:45 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:43853 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0A3Eip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 23:38:45 -0500
Subject: Re: why is nf_conntrack_htable_size exported?
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
In-Reply-To: <1264825931.7156.2.camel@tonnant>
References: <1264825931.7156.2.camel@tonnant>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Fri, 29 Jan 2010 23:38:36 -0500
Message-Id: <1264826316.7499.1.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 23:32 -0500, Jon Masters wrote:

> Can someone tell me why nf_conntrack_htable_size is both an exported
> symbol, and available in sysfs to be changed?

Ah, ignore me, it does go through a function, it's just that if it's
already zero we assume it's "init time", which isn't true if the value
has otherwise been fiddled with - I think that assumption probably is
worth looking at anyway, and it's worth the hashing functions looking to
see if the value is NULL, to catch that aswell.

Jon.


