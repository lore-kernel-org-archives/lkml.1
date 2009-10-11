Return-Path: <linux-kernel-owner+w=401wt.eu-S1751035AbZJKSwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035AbZJKSwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbZJKSwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 14:52:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51513 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbZJKSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 14:52:21 -0400
X-Sasl-enc: 2kvexFqKOxhMd/wvmGEW/jewvVsvUqVOvtLIejfwvQEW 1255287079
Date: Sun, 11 Oct 2009 15:51:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
Message-ID: <20091011185114.GB18578@khazad-dum.debian.net>
References: <200910100322.36857.thomas.schlichter@web.de>
 <4AD00C89.3000503@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD00C89.3000503@linux.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Oct 2009, Arjan van de Ven wrote:
> >I've found a problem with X.org not setting up MTRR for the
> >framebuffer memory. After I investigated I think this is not a
> >X.org problem, but a kernel issue.
> 
> is there any CPU left that does not support PAT ?

A few million of them.  Like every Centrino laptop out there, unless the
kernel blacklist for PAT on Intel CPUs is wrong.

> eg in other words, should we try instead to get PAT working for you?

Is it even possible?  Can you get Intel to fix my Pentium M?  I'd be quite
happy to test any microcode updates you send my way :)

As things stand right now, you can assume PAT will be there in 2015 or
thereabouts.  Machine models that can run Linux have a service life of
around 15 years.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
