Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbXDXEgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbXDXEgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXDXEgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:36:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:39344 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161552AbXDXEgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:36:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18YI2wK2XYYw2dFF5E19TWeiPajVqdZylE4pTFicN
	d3BHCX7nhmGPNE
Subject: Re: [RFC] another scheduler beater
From: Mike Galbraith <efault@gmx.de>
To: davidsen@posidon.tmr.com
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <462D2B4E.7050009@tmr.com>
References: <462D2B4E.7050009@tmr.com>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 06:36:33 +0200
Message-Id: <1177389393.6299.16.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 17:55 -0400, Bill Davidsen wrote:

> Based on just this script as load I would say renice on X isn't a good 
> thing. Based on one small test, I would say that renice of X in 
> conjunction with heavy disk i/o and a single fast scrolling xterm (think 
> kernel compile) seems to slow the raid6 thread measurably.

Yeah, I was testing a UP kernel yesterday.  It doesn't take much renice
to severely injure the competition with them having no place else to go.
Nice -19 is definitely overkill.

	-Mike

