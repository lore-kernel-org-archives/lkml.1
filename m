Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbXLUVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbXLUVSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbXLUVSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:18:34 -0500
Received: from 1wt.eu ([62.212.114.60]:1045 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbXLUVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:18:33 -0500
Date: Fri, 21 Dec 2007 22:16:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       jmorris@namei.org, alan@redhat.com, chrisw@redhat.com,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       solar@openwall.com, wtarreau@hera.kernel.org
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
Message-ID: <20071221211602.GA14811@1wt.eu>
References: <1198101545.6197.52.camel@localhost.localdomain> <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr> <1198269079.3732.3.camel@localhost.localdomain> <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Fri, Dec 21, 2007 at 10:10:24PM +0100, Jan Engelhardt wrote:
> 
> On Dec 21 2007 15:31, Eric Paris wrote:
> >On Thu, 2007-12-20 at 00:29 +0100, Jan Engelhardt wrote:
> >> On Dec 19 2007 16:59, Eric Paris wrote:
> >> >
> >> >+config SECURITY_DEFAULT_MMAP_MIN_ADDR
> >> >+        int "Low address space to protect from user allocation"
> >> 
> >> Hm, should not this be 'hex'?
> >
> >I guess it could be, but the input for /proc/sys/vm/mmap_min_addr is
> >base 10 as well
> 
> sysfs is autobase, i.e. echo "0xb000" >/sys/foo will Do The Right Thing.

yes but if you cat  /proc/sys/vm/mmap_min_addr, it returns in base 10.
While most of us have no problem doing an instant conversion, many
people will find it painful to convert the output of cat before copying
it into their .config.

I'm generally for hex, but here I'd prefer to stay with the in-place
format which is already decimal. And as you said, people can still
write the hex value into /proc/sys if they want to.

Regards,
Willy

