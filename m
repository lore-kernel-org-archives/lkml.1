Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZLRSLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZLRSLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbZLRSLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:11:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37142 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbZLRSLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:11:36 -0500
Date: Fri, 18 Dec 2009 19:11:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: lenb@kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5 -v2] acpi, apei, APEI supporting infrastructure
Message-ID: <20091218181123.GA1470@ucw.cz>
References: <1260429417.15264.394.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260429417.15264.394.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-12-10 15:16:57, Huang Ying wrote:
> APEI stands for ACPI Platform Error Interface, which allows to report
> errors (for example from the chipset) to the operating system. This
> improves NMI handling especially. In addition it supports error
> serialization and error injection.
> 
> For more information about APEI, please refer to ACPI Specification
> version 4.0, chapter 17.
> 
> This patch provides some common functions used by more than one APEI
> tables, mainly framework of interpreter for EINJ and ERST.
> 
> A machine readable language is defined for EINJ and ERST for OS to
> execute, and so to drive the firmware to fulfill the corresponding
> functions. The machine language for EINJ and ERST is compatible, so a
> common framework is defined for them.

Does this mean we'll now try to run acpi interrpretter from NMI
context?

I don't see how that can work; NMI is really special... 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
