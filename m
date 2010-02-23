Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0BWIM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:12:26 -0500
Received: from poutre.nerim.net ([62.4.16.124]:50689 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0BWIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:12:24 -0500
Date: Tue, 23 Feb 2010 09:12:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mike Rapoport <mike@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
       linux-i2c@vger.kernel.org, Denis Turischev <denis@compulab.co.il>,
       Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v3 2/3] i2c: convert i2c-isch to platform_device
Message-ID: <20100223091221.086ff17b@hyperion.delvare>
In-Reply-To: <4B837D0C.3000708@compulab.co.il>
References: <4B73DAEE.5080400@compulab.co.il>
	<4B73DBB2.7020601@compulab.co.il>
	<4B7C0E5D.3070909@compulab.co.il>
	<4B812B42.2090405@compulab.co.il>
	<4B837D0C.3000708@compulab.co.il>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, 23 Feb 2010 09:00:28 +0200, Mike Rapoport wrote:
> Hi Jean,
> 
> Denis Turischev wrote:
> > v2: there is no acpi_check_region, it will be implemented in mfd-core
> > v3: patch refreshed against the latest Linus tree
> > 
> > Signed-off-by: Denis Turischev <denis@compulab.co.il>
> 
> Any chance this can go to 2.6.34?

I can add my

Acked-by: Jean Delvare <khali@linux-fr.org>

but the patch itself would rather go through Samuel's mfd tree. The
different patches depend on each other so pushing them through
different trees would cause trouble.

-- 
Jean Delvare
