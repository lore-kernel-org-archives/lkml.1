Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZJEPpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZJEPpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZJEPpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:45:54 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:37260 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753743AbZJEPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:45:54 -0400
Date: Mon, 5 Oct 2009 11:39:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
In-Reply-To: <4ACA13A1.4090107@kernel.org>
Message-ID: <alpine.DEB.1.10.0910051138060.16359@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <4AC7279B.3050901@kernel.org> <alpine.DEB.1.10.0910051038410.16359@gentwo.org> <4ACA0A4F.3090004@kernel.org> <alpine.DEB.1.10.0910051105070.16359@gentwo.org>
 <4ACA0EFD.4070607@kernel.org> <alpine.DEB.1.10.0910051126370.16359@gentwo.org> <4ACA13A1.4090107@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Tejun Heo wrote:

> I'm under the impression that ia64 needs its percpu areas setup
> earlier during the boot so I'm not sure what you have in mind but as
> long as the call isn't scattered over different setup_per_cpu_areas()
> implementations, I'm okay.

Currently it does. But there must be some way to untangle that mess.

