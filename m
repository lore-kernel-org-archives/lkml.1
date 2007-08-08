Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbXHHJs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbXHHJs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbXHHJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:48:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:47529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355AbXHHJso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:48:44 -0400
Subject: Re: [PATCH] thinkpad acpi module_exit fix
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Dave Young <hidave.darkstar@gmail.com>
Cc: hmh@hmh.eng.br, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070808164334.GA2732@darkstar.te-china.tietoenator.com>
References: <20070808164334.GA2732@darkstar.te-china.tietoenator.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 08 Aug 2007 11:48:40 +0200
Message-Id: <1186566520.8780.140.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 16:43 +0000, Dave Young wrote:
> Hi,
> 
> [This fix is not very good for the global variable, any comments are
> welcome.]
> 
> The thinkpad_acpi module_init fail out entrace is not very properly. if
> failing before register driver or before create sysfs file, the
> module_exit will try to remove nonexist sysfs files, the kernel will
> oops.
This one is already fixed in Len's git tree in the test branch and will
get merged to Linus soon (commit id:
ac36393de6034be7266264a435360e7628849005).

The (similar) patch got posted on linux-acpi with subject:
[PATCH 05/12] ACPI: thinkpad-acpi: fix the module init failure path
(Fri,  3 Aug 2007 18:33:38)

    Thomas

