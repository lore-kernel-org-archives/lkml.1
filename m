Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbXKGKfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbXKGKfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 05:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXKGKfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 05:35:08 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:53890 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXKGKfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:35:07 -0500
Date: Wed, 7 Nov 2007 02:34:49 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107103449.GB14646@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107003454.GA13374@kroah.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, Nov 06, 2007 at 04:34:54PM -0800, Greg KH wrote:
> Here's a patch against my current tree that gets the perfmon code
> building and hopefully working.
> 
Thanks for your quick help.

> Note, it needs the kobject_create_and_register() patch which is in my
> tree, but I do not think it made it to -mm yet.  The next -mm cycle
> should have it.
> 
> Also, the sysfs usage in the perfmon code is quite strange and not
> documented at all.  Yes, there is a little bit in the documentation
> about what a few of the files do, but there are _way_ more files and
> even directories being created under /sys/kernel/perfmon/ that are not
> documented at all here.
> 
The full documentation for /sys/kernel/perfmon is in Documentation/perfmon2.txt

> If you document this stuff, I think I can clean up your sysfs code a
> lot, making things simpler, easier to extend, and easier to understand.
> But as it is, I don't want to break anything as it's totally unknown how
> this stuff is supposed to work...
> 
I certainly welcome your help.

> Hint, use the Documentation/ABI directory to document your sysfs
> interfaces, that is what it is there for...
> 
I will move the description from perfmon2.txt to its own file in
ABI/testing.

--
-Stephane
