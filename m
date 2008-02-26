Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbYBZRol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbYBZRol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762359AbYBZRoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:44:20 -0500
Received: from khc.piap.pl ([195.187.100.11]:45225 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761113AbYBZRoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:44:19 -0500
To: Alan Cox <alan@redhat.com>
Cc: davids@webmaster.com, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
References: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com>
	<m3d4qj90zm.fsf@maximus.localdomain>
	<m34pbv8x8s.fsf@maximus.localdomain>
	<20080226172143.GA5445@devserv.devel.redhat.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 26 Feb 2008 18:44:18 +0100
In-Reply-To: <20080226172143.GA5445@devserv.devel.redhat.com> (Alan Cox's message of "Tue\, 26 Feb 2008 12\:21\:43 -0500")
Message-ID: <m34pbvsjd9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@redhat.com> writes:

>> Actually I think the _GPL exports are really harmful - somebody
>> distributing a binary module may claim he/she doesn't violate the GPL
>> because the module uses only non-GPL exports. OTOH GPL symbols give
>
> They can claim that anyway. The can claim to be alien life forms too. Claim
> is not the same as legal decision.

Sure but it may be now easier to convince the judge they are right. Of
course if they aren't using GPL exports - if they are, perhaps harder.

> From what I've seen its helped make binary
> module abusers more cautious.

Those not using _GPL exports?
-- 
Krzysztof Halasa
