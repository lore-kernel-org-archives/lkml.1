Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbXLUUc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbXLUUc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXLUUcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:32:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbXLUUcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:32:16 -0500
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
From: Eric Paris <eparis@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr>
References: <1198101545.6197.52.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 15:31:19 -0500
Message-Id: <1198269079.3732.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 00:29 +0100, Jan Engelhardt wrote:
> On Dec 19 2007 16:59, Eric Paris wrote:
> >
> >+config SECURITY_DEFAULT_MMAP_MIN_ADDR
> >+        int "Low address space to protect from user allocation"
> 
> Hm, should not this be 'hex'?

I guess it could be, but the input for /proc/sys/vm/mmap_min_addr is
base 10 as well so I figured consistency was a good thing.  Do you have
strong feelings?  I guess so since you posted about it.

-Eric

