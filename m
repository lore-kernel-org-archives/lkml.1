Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZKUXVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZKUXVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 18:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZKUXVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 18:21:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36171 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753145AbZKUXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 18:21:18 -0500
Date: Sat, 21 Nov 2009 23:23:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: swan.r.l@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091121232320.3262636c@lxorguk.ukuu.org.uk>
In-Reply-To: <20091121222319.GA3905@swanrl.gmail.com>
References: <20091121222319.GA3905@swanrl.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can provide reasonably stripped down code which demonstrates the
> problem.  It has been reproduced by one other person, though his delay
> was about 2ms.

I would expect that.

I guess the obvious question would be "why are you using ptys for latency
sensitive communications ?" They now queue like other ttys which fixes a
whole ton of stuff but does mean they have normal tty latencies.

Alan
