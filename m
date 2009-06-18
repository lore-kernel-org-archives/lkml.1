Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZFRWK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZFRWK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZFRWKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:10:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44938 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691AbZFRWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:10:22 -0400
X-Sasl-enc: g7efV93taiqlZMZsC2hRfIVfMHOAWTjcwkgWZTBjxxzN 1245363023
Date: Thu, 18 Jun 2009 19:10:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joerg Platte <jplatte@naasa.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30] Kernel bug with dock driver
Message-ID: <20090618221020.GA2979@khazad-dum.debian.net>
References: <200906142100.48621.jplatte@naasa.net> <200906161125.00685.jplatte@naasa.net> <20090617123440.GA400@khazad-dum.debian.net> <200906182322.54566.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906182322.54566.jplatte@naasa.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Joerg Platte wrote:
> Am Wednesday, 17. June 2009 schrieb Henrique de Moraes Holschuh:
> > If it causes a NULL derreference, it means someone has changed API and did
> > NOT change all callsites.  It is that simple.
> >
> thinkpad_acpi: dev_name() is returning NULL

There it is.  "Someone set us up the bomb."

> Hope it helps...

Yes, it does.  Thank you.  Now at least I know what to look for.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
