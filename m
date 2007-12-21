Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbXLUWEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbXLUWEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbXLUWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:04:23 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51923 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbXLUWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:04:20 -0500
Date: Fri, 21 Dec 2007 23:04:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Willy Tarreau <w@1wt.eu>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       jmorris@namei.org, alan@redhat.com, chrisw@redhat.com,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       solar@openwall.com, wtarreau@hera.kernel.org
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
In-Reply-To: <20071221211602.GA14811@1wt.eu>
Message-ID: <Pine.LNX.4.64.0712212303410.18570@fbirervta.pbzchgretzou.qr>
References: <1198101545.6197.52.camel@localhost.localdomain>
 <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr>
 <1198269079.3732.3.camel@localhost.localdomain>
 <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
 <20071221211602.GA14811@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21 2007 22:16, Willy Tarreau wrote:
>Hi Jan,
>
>> >> >+config SECURITY_DEFAULT_MMAP_MIN_ADDR
>> >> >+        int "Low address space to protect from user allocation"
>> >> 
>> >> Hm, should not this be 'hex'?
>> >
>> >I guess it could be, but the input for /proc/sys/vm/mmap_min_addr is
>> >base 10 as well
>> 
>> sysfs is autobase, i.e. echo "0xb000" >/sys/foo will Do The Right Thing.
>
>yes but if you cat  /proc/sys/vm/mmap_min_addr, it returns in base 10.

sysfs should probably be tuned to output it in a preferred base.
