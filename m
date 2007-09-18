Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbXIRUUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbXIRUUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXIRUUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:20:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbXIRUUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:20:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Charles N Wyble <charles@thewybles.com>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
Date: Tue, 18 Sep 2007 22:20:26 +0200
User-Agent: KMail/1.9.6
Cc: virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1189747054.7262.34.camel@localhost.localdomain> <200709181257.41530.ak@suse.de> <46F02F50.5000001@thewybles.com>
In-Reply-To: <46F02F50.5000001@thewybles.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182220.27311.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> 	Why is making something default y a bad idea? 
> Those most likely to care can turn it off. Is there a harmful effect
> from leaving it on if its not being used?

Running yes "" | make oldconfig to upgrade kernel configs is standard practice
and you definitely don't want to have all kinds of random new unnecessary features
be turned on then.

Besides paravirt by itself is pretty useless; you need typically quite
complex other options set to do any meaningfull virtualization.

The only reason to use default y is in options that are not user visible
and have a reasonable default or things that cause direct boot failures
when upgrading old configurations. That all doesn't apply here.

Besides it's bad taste and taste is very important.

-Andi
