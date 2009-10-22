Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZJVCr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZJVCr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZJVCr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:47:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:43883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZJVCr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:47:28 -0400
Date: Wed, 21 Oct 2009 19:48:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Message-ID: <20091021194822.72895c46@infradead.org>
In-Reply-To: <20091022004919.GT32470@one.firstfloor.org>
References: <1256167297.4768.14.camel@localhost.localdomain>
	<20091021174804.3885db37@infradead.org>
	<20091022004919.GT32470@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 02:49:19 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > you're pretty much the first now who touches ->comm from
> > not-the-thread-itself.... are you sure that is safe?
> 
> It's not, there is no locking. On the other hand nothing should crash,
> just users might see half rewritten data.

.. with strings this is tricky though.. if the new string is longer
than the old one the terminating zero might just be missed etc.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
