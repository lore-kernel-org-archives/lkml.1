Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYIYIij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYIYIij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYIYIia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:38:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:35628 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYIYIia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:38:30 -0400
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
	hardirq preemption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Milton Miller <miltonm@bga.com>, Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080925094231.442a4c75@bull.net>
References: <200809231743.23828.ossthema@de.ibm.com>
	 <20080915100406.342e027a@bull.net>
	 <200809240958.m8O9wM7k010996@sullivan.realtime.net>
	 <1222251467.8277.73.camel@pasglop> <20080924143552.29a14f10@bull.net>
	 <1222290917.8277.83.camel@pasglop> <20080925091827.29b5087c@bull.net>
	 <1222327361.8277.179.camel@pasglop>  <20080925094231.442a4c75@bull.net>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 18:36:19 +1000
Message-Id: <1222331779.8277.183.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   Do you mean creating a custom fasteoi handler into xics.c? Also, it's
> not clear to me from looking at the code how you go about changing the
> cpu priority.

Yup. I think the priority is the CPPR.. Milton can give you more
details, if not, I'll pick it up tomorrow when at the office.

Ben.

