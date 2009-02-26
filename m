Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZBZTrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZBZTrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZBZTrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:47:06 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:60498 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZBZTrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:47:05 -0500
Message-ID: <49A6F1AC.4090305@krogh.cc>
Date: Thu, 26 Feb 2009 20:46:52 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Olsen <dolsen@lnxi.com>, Ryan Jackson <rjackson@lnxi.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A679E8.1010301@krogh.cc>	 <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain>	 <49A6EE17.4070102@krogh.cc> <1235677008.8730.176.camel@macbook.infradead.org>
In-Reply-To: <1235677008.8730.176.camel@macbook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2009-02-26 at 19:31 +0000, Jesper Krogh wrote:
>> 1) pick the distro .config
>> 2) make oldconfig
> 
> So it should have been a module, not built-in?

It is a module.. and it somehow gets auto-loaded on my system. (not 
listed in /etc/modules).

$ grep -i ck804xrom /boot/config-2.6.29-rc6
CONFIG_MTD_CK804XROM=m

Same in the distro .config
$ grep -i ck804xrom /boot/config-2.6.24-23-server
CONFIG_MTD_CK804XROM=m


>> 3) Let the kernel load what it think it needs.
> 
> That part at least ought to be disabled -- we don't let this driver
> autoload, because unless you _know_ you need it, you don't need it.
> 
> It's for overwriting your BIOS.

Oh. Thanks for your time... I'll just make sure to disable it from now on.

-- 
Jesper

