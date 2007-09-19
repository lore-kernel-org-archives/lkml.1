Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbXISP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbXISP6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXISP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:58:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58679 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbXISP6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:58:06 -0400
Date: Wed, 19 Sep 2007 08:56:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Problem: one driver and 4 instances with different parameters
Message-Id: <20070919085651.1d8f8359.randy.dunlap@oracle.com>
In-Reply-To: <p73abrjvz5d.fsf@bingen.suse.de>
References: <016a01c7fa89$ff51e850$b4fefea9@andrey>
	<p73abrjvz5d.fsf@bingen.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2007 10:26:54 +0200 Andi Kleen wrote:

> "Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de> writes:
> 
> > I have one driver, but I need to run 4 instances of it (I run insmod
> > with different parameters) .
> > 
> > But when I try to install the second driver I've got an error, that
> > driver with this name exists.
> 
> The standard trick to do that is to copy the module binary to four different
> names (the module name is not encoded in the binary)
> 
> But it would be better to just fix the driver to allow this
> with a single instance with some other run time configuration
> mechanism and not use module parameters (which 
> are generally somewhat deprecated anyways) 
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Eh?  Do you mean for IO,mem,irq type settings?  If so, then yes, ok.
Otherwise please explain what you mean...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
