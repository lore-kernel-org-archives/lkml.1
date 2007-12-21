Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbXLUVKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbXLUVKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbXLUVK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:10:26 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49342 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbXLUVKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:10:25 -0500
Date: Fri, 21 Dec 2007 22:10:24 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
In-Reply-To: <1198269079.3732.3.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
References: <1198101545.6197.52.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr>
 <1198269079.3732.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21 2007 15:31, Eric Paris wrote:
>On Thu, 2007-12-20 at 00:29 +0100, Jan Engelhardt wrote:
>> On Dec 19 2007 16:59, Eric Paris wrote:
>> >
>> >+config SECURITY_DEFAULT_MMAP_MIN_ADDR
>> >+        int "Low address space to protect from user allocation"
>> 
>> Hm, should not this be 'hex'?
>
>I guess it could be, but the input for /proc/sys/vm/mmap_min_addr is
>base 10 as well

sysfs is autobase, i.e. echo "0xb000" >/sys/foo will Do The Right Thing.

>so I figured consistency was a good thing.  Do you have
>strong feelings?  I guess so since you posted about it.
