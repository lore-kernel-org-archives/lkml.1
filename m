Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXJBX2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXJBX2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXJBX2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:28:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbXJBX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:28:04 -0400
Date: Tue, 2 Oct 2007 16:26:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anders =?UTF-8?B?Qm9zdHI=?= =?UTF-8?B?w7Zt?= 
	<anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: PROBLEM: high load average when idle
Message-ID: <20071002162613.54c3ef43@laptopd505.fenrus.org>
In-Reply-To: <4702C756.8090108@redhat.com>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
	<20071002150748.906970bc.akpm@linux-foundation.org>
	<4702C756.8090108@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 18:33:58 -0400
> Or, everybody wakes up at once right when we are taking a sample.  :)

nice try but we sample every timer tick; this code being timer driven
makes it what you say it is regardless of *which* timer tick it
happens at ;)
