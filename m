Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885Ab0AUO2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0AUO2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 09:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671Ab0AUO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 09:28:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:58541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751027Ab0AUO2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 09:28:35 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18qedVGZL4qcUiRNWLrzQFolIhDBXndW54Kcc65n4
	wRKpJL7QVLQ3rS
Subject: Re: perf top: losing events?
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100121122224.GA21083@ghostprotocols.net>
References: <1264052528.26323.13.camel@marge.simson.net>
	 <20100121122224.GA21083@ghostprotocols.net>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 15:28:32 +0100
Message-Id: <1264084112.5933.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 10:22 -0200, Arnaldo Carvalho de Melo wrote:

> Can you check if this one helps? 

Made interrupt count correct, but symbols aren't mapped after the task
forks it seems.  At least, in event__preprocess_sample(), after
thread__find_addr_location(), al->map is NULL a LOT.

	-Mike

