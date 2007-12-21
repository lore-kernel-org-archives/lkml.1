Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbXLUW7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbXLUW7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXLUW7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:59:45 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33944 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbXLUW7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:59:44 -0500
Date: Fri, 21 Dec 2007 23:59:43 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: Willy Tarreau <w@1wt.eu>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
In-Reply-To: <20071221223526.GC24780@kroah.com>
Message-ID: <Pine.LNX.4.64.0712212358440.25803@fbirervta.pbzchgretzou.qr>
References: <1198101545.6197.52.camel@localhost.localdomain>
 <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr>
 <1198269079.3732.3.camel@localhost.localdomain>
 <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
 <20071221211602.GA14811@1wt.eu> <Pine.LNX.4.64.0712212303410.18570@fbirervta.pbzchgretzou.qr>
 <20071221223526.GC24780@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21 2007 14:35, Greg KH wrote:
>> >> >I guess it could be, but the input for /proc/sys/vm/mmap_min_addr is
>> >> >base 10 as well
>> >> 
>> >> sysfs is autobase, i.e. echo "0xb000" >/sys/foo will Do The Right Thing.
>> >
>> >yes but if you cat  /proc/sys/vm/mmap_min_addr, it returns in base 10.
>> 
>> sysfs should probably be tuned to output it in a preferred base.
>
>Again, this is sysctl, not sysfs.  two very different things...
>
Argh... :)  Just shows that /proc is the wrong place for system variables.

Well, module_params(integer) are autobase, and that's all I needed so 
far :-D
