Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbXGFNPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbXGFNPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbXGFNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:15:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXGFNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:15:04 -0400
Subject: Re: [-mm PATCH 0/7] Memory controller introduction
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
In-Reply-To: <468CB658.7000204@openvz.org>
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop>
	 <468CB658.7000204@openvz.org>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 15:14:50 +0200
Message-Id: <1183727690.7054.104.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 13:14 +0400, Pavel Emelianov wrote:

> Separate limits for RSS and RSS+pagecache are also a must.

This I still disagree upon. Page-cache limits are orthogonal to
containers and not a requirement for containers. If you want such a
feature get it in Linux proper and don't sneak it in the backdoor via
containers.



