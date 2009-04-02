Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZDBLq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZDBLq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZDBLqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:46:19 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:53142 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZDBLqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:46:18 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/6] perf_counter: move the event overflow output bits
 to record_type
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402114330.GA24618@elte.hu>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.151921176@chello.nl>  <20090402114330.GA24618@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 13:47:13 +0200
Message-Id: <1238672833.8530.5904.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 13:43 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > -	PERF_EVENT_OVERFLOW	= 1UL << 31,
> > +	PERF_EVENT_COUNTER_OVERFLOW	= 1UL << 31,
> 
> >  	header.type = PERF_EVENT_OVERFLOW;
> 
> i fixed the obvious sed failure there :)

Yeah, lost a refresh :/

