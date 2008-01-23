Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbYAWP6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbYAWP6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYAWP6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:58:14 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38450 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYAWP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:58:13 -0500
Date: Wed, 23 Jan 2008 16:58:12 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Thomas, Sujith" <sujith.thomas@intel.com>
cc: Christoph Hellwig <hch@infradead.org>, "Zhang, Rui" <rui.zhang@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 9/10] introduce intel_menlow platform specific driver
In-Reply-To: <05B550FD4BD2014E841D83547B6260080281AE80@bgsmsx411.gar.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0801231656350.12676@fbirervta.pbzchgretzou.qr>
References: <1200556278.2935.118.camel@acpi-sony.sh.intel.com>
 <20080121095331.GA5333@infradead.org> <05B550FD4BD2014E841D83547B6260080281AE80@bgsmsx411.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 21 2008 19:49, Thomas, Sujith wrote:
>>> 
>>> +MODULE_AUTHOR("Thomas Sujith");
>>> +MODULE_AUTHOR("Zhang Rui");
>> 
>> I've never seen a driver with two MODULE_AUTHOR statements before.
>> Does this actually work?  What does modinfo -F author say for your module?
>
>There is nothing wrong in giving 2 MODULE_AUTHORS. Both will be
>displayed in the command modinfo -F author.

Coding-wise, it is no problem. MODULE_* gets transformed into char
__mod_*line, so as long as you have the two MODULE_AUTHOR() macros on
different lines, it will work.

It is cool to actually see this working out-of-the-box with modinfo
too (even without the -F option). Could decouple a few AUTHOR lines.
