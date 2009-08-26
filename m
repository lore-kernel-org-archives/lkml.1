Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZHZJ1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZHZJ1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZHZJ1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:27:06 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:8775 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbZHZJ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:27:05 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:sched/core] sched: Avoid division by zero
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jes@sgi.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <4A94FD58.8060207@kernel.org>
References: <1250855934.7538.30.camel@twins>
	 <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org>
	 <1251227486.7538.1174.camel@twins>  <4A94FD58.8060207@kernel.org>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 11:25:59 +0200
Message-Id: <1251278759.1329.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 02:16 -0700, Yinghai Lu wrote:
> Peter Zijlstra wrote:
> > Yinghai, Balbir, Arjan,
> > 
> > Could you try the below to see if that fully does away with the /0 in
> > the group scheduler thing?
> 
> yes this one fix the problem.

Awesome, I'll polish her up a bit and send it to Ingo.

Thanks!

