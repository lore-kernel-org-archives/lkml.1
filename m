Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYDCQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYDCQQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbYDCQP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:15:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42392 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbYDCQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:15:58 -0400
Date: Thu, 3 Apr 2008 09:14:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tom Horsley <tom.horsley@ccur.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: module parameters versus kernel command line
Message-Id: <20080403091444.827d954a.randy.dunlap@oracle.com>
In-Reply-To: <20080403120425.232cb1ba@tomh>
References: <20080403090053.56f243df@tomh>
	<20080403083953.42ea3f1d.randy.dunlap@oracle.com>
	<20080403120425.232cb1ba@tomh>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 12:04:25 -0400 Tom Horsley wrote:

> On Thu, 3 Apr 2008 08:39:53 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:

Please use reply-to-all.

> > Module parameters for modules that are built into the kernel image
> > are specified on the kernel command line with the module name plus
> > '.' plus parameter name, with '=' and value if appropriate, such as:
> > 
> > 	usbcore.blinkenlights=1
> 
> I know that part, I'm just wondering if it would be nice to have
> even dynamically loaded modules notice the kernel option
> so that the "usbcore" module would see the "blinkenlights=1"
> parameter from the kernel boot options when dynamically loaded?
> 
> That way, you wouldn't have to stop and figure out if a module
> was static or dynamic to decide if you need to edit the grub boot
> line or the modprobe.conf file.

OK, that makes some sense to me.

Rusty added to cc for his objective viewpoint.

---
~Randy
