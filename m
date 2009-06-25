Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZFYNQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZFYNQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZFYNQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:16:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60397 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752326AbZFYNQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:16:23 -0400
Date: Thu, 25 Jun 2009 14:17:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David =?ISO-8859-14?B?SORyZGVtYW4=?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP
           id WEC1022)
Message-ID: <20090625141752.740e081d@lxorguk.ukuu.org.uk>
In-Reply-To: <c17c39d3458ffa3aebee03ff26d90c23.squirrel@www.hardeman.nu>
References: <20090624213645.GA18843@hardeman.nu>
	<20090624234501.3d35642f@lxorguk.ukuu.org.uk>
	<55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu>
	<20090625134946.46109bac@lxorguk.ukuu.org.uk>
	<c17c39d3458ffa3aebee03ff26d90c23.squirrel@www.hardeman.nu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which way of stopping the serial layer from grabbing the port did you have
> in mind?
> 
> If I call uart_remove_one_port, I'd need to get struct uart_driver *drv
> and struct uart_port *port from somewhere. Also, it'd be quite ugly to
> have /dev/ttyX appear and magically disappear during boot (since 8250 is
> compiled in with most distro kernels and my driver would be a module which
> would be loaded much later).
> 
> The only alternative I could think of would be to get the serial core to
> check with acpi_check_resource_conflict for ports that have not been
> discovered via PNP/ACPI?

You can vanish it with setserial as stands. There isn't a good
interface for doing that from kernel side but as you can see from
setserial the infrastructure is all there to add it.

