Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYFRONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYFRONS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYFRONE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:13:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbYFROND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:13:03 -0400
Subject: Re: [BUG: NULL pointer dereference] cgroups and	RT
	scheduling	interact badly.
From: Peter Zijlstra <peterz@infradead.org>
To: "Daniel K." <dk@uw.no>
Cc: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <48590F09.7000406@uw.no>
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>
	 <4856671B.1020304@uw.no>  <1213624312.16944.104.camel@twins>
	 <1213627148.16944.106.camel@twins>  <485682B0.8010805@uw.no>
	 <1213629536.16944.109.camel@twins> <1213692557.16944.153.camel@twins>
	 <4857AD38.2090601@uw.no>
	 <1213732878.3223.95.camel@lappy.programming.kicks-ass.net>
	 <48583122.7080409@uw.no> <1213789854.16944.216.camel@twins>
	 <48590F09.7000406@uw.no>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 16:12:52 +0200
Message-Id: <1213798372.16944.226.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 15:35 +0200, Daniel K. wrote:

> I am happy to say that this nailed it squarely on the head. I no longer
> see any of the Oops'es I could quite easily trigger before. I added my
> Tested-by, please add it to the patch you sent yesterday as well.

Done, and pushed to Ingo - should hopefully show up in a git tree near
you soonish.

> I still have a few gripes with RR scheduling, but that is a topic for
> another mail.

Please CC me when you get around to writing it.

