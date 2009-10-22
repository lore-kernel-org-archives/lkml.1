Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZJVAtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZJVAtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZJVAtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:49:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45130 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZJVAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:49:15 -0400
Date: Thu, 22 Oct 2009 02:49:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Message-ID: <20091022004919.GT32470@one.firstfloor.org>
References: <1256167297.4768.14.camel@localhost.localdomain> <20091021174804.3885db37@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021174804.3885db37@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> you're pretty much the first now who touches ->comm from
> not-the-thread-itself.... are you sure that is safe?

It's not, there is no locking. On the other hand nothing should crash,
just users might see half rewritten data.
-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
