Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZLDJtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZLDJtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZLDJtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:49:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:57436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbZLDJtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:49:31 -0500
Subject: Re: [PATCH 1/3] sched: fix missing sched tunable recalculation on
 cpu add/remove
From: Peter Zijlstra <peterz@infradead.org>
To: ehrhardt@linux.vnet.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, Holger.Wolf@de.ibm.com,
       epasch@de.ibm.com, schwidefsky@de.ibm.com
In-Reply-To: <1259579808-11357-2-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
	 <1259579808-11357-2-git-send-email-ehrhardt@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 10:49:14 +0100
Message-ID: <1259920154.3977.1822.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 12:16 +0100, ehrhardt@linux.vnet.ibm.com wrote:

> +	unsigned int cpus = max(num_online_cpus(), 8U);

Hehe, you copied my bug too ;-)

I made that min() now.

