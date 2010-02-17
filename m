Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0BQKol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:44:41 -0500
Received: from poutre.nerim.net ([62.4.16.124]:52325 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0BQKoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:44:38 -0500
Date: Wed, 17 Feb 2010 11:44:33 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Denis Turischev <denis@compulab.co.il>
Cc: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Message-ID: <20100217114433.6a405bd3@hyperion.delvare>
In-Reply-To: <4B7BBEE5.3040104@compulab.co.il>
References: <4B73DAEE.5080400@compulab.co.il>
	<4B73DB4B.40501@compulab.co.il>
	<201002161157.47196.david-b@pacbell.net>
	<20100216224947.5c46ff86@hyperion.delvare>
	<4B7BBEE5.3040104@compulab.co.il>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 12:03:17 +0200, Denis Turischev wrote:
> Jean Delvare wrote:
> > Might be a good idea to use acpi_check_resource_conflict() or similar
> > before instantiating the platform devices.
> 
> May be it worth to add such resource check directly to mfd_add_device function?

I'm not sure. I suspect that many MFD devices are never used on
ACPI-aware systems, so it might be considered overkill. OTOH the calls
resolve to empty stubs when ACPI is disabled so... I have no objection,
but I'll leave the decision to somebody else ;)

-- 
Jean Delvare
