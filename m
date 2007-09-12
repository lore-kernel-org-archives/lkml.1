Return-Path: <linux-kernel-owner+w=401wt.eu-S934560AbXILPwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbXILPwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 11:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933226AbXILPwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 11:52:31 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:29183 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbXILPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 11:52:30 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Satyam Sharma <satyam@infradead.org>, Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] ehca_irq: Misc cpuinit section annotations and #ifdef cleanups
Date: Wed, 12 Sep 2007 17:52:26 +0200
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0708230456100.2049@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708230456100.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121752.27310.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2007 01:28, Satyam Sharma wrote:
> 
> * Replace {un}register_cpu_notifier with {un}register_hotcpu_notifier
>   thereby losing a couple of #ifdef HOTPLUG_CPU pairs.
> * Move comp_pool_callback_nb declaration to below that of callback
>   function so that initialization of .notifier_call and .priority can
>   occur at build time itself and not runtime.
> * Mark the notifier_block (and callback function, and another static
>   function used by it) as __cpuinit{data} for the sake of consistency
>   and remove enclosing #ifdef. (This may increase size for modular
>   build of this module, however, because these are no longer dropped
>   unconditionally now.)
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Looks okay to me.

Acked-by: Joachim Fenkes <fenkes@de.ibm.com>

