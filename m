Return-Path: <linux-kernel-owner+w=401wt.eu-S1767162AbXDTRdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767162AbXDTRdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993306AbXDTRdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:33:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993304AbXDTRdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:33:53 -0400
Date: Fri, 20 Apr 2007 13:33:37 -0400
From: Dave Jones <davej@redhat.com>
To: "Preston A. Elder" <prez@goth.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420173337.GD20118@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4628F00B.3010304@goth.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 12:53:31PM -0400, Preston A. Elder wrote:

 > Linux agpgart interface v0.101 (c) Dave Jones
 > agpgart: DEBUG 0
 > agpgart: DEBUG 1
 > __pci_register_driver: In function
 > __pci_register_driver: driver = agpgart-amdk7, multithread = 0
 > __pci_register_driver: Before Spinlock
 > __pci_register_driver: Before List Init
 > __pci_register_driver: Before Driver Register
 > __pci_register_driver: Error = 0
 > __pci_register_driver: Returning 0
 > 
 > The DEBUG 0 and 1 are coming from agp_amdk7_init()
 > There is a DEBUG 2 at the top of agp_amdk7_probe(), even before
 > pci_find_capability, but the function never gets called.

bus_add_driver() returns 0 on error, but there's a few different
cases it can fail, which isn't helpful.  Add some printk's to
the error cases there, and see if that gives any more clues.

	Dave

-- 
http://www.codemonkey.org.uk
