Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZFYNeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZFYNeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZFYNeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:34:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33222 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752326AbZFYNeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:34:05 -0400
Date: Thu, 25 Jun 2009 14:35:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David =?ISO-8859-14?B?SORyZGVtYW4=?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP
                id WEC1022)
Message-ID: <20090625143533.19ff85e5@lxorguk.ukuu.org.uk>
In-Reply-To: <a4495505aea6a06643c8072fd790fb5d.squirrel@www.hardeman.nu>
References: <20090624213645.GA18843@hardeman.nu>
	<20090624234501.3d35642f@lxorguk.ukuu.org.uk>
	<55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu>
	<20090625134946.46109bac@lxorguk.ukuu.org.uk>
	<c17c39d3458ffa3aebee03ff26d90c23.squirrel@www.hardeman.nu>
	<20090625141752.740e081d@lxorguk.ukuu.org.uk>
	<a4495505aea6a06643c8072fd790fb5d.squirrel@www.hardeman.nu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 15:28:31 +0200 (CEST)
David Härdeman <david@hardeman.nu> wrote:

> On Thu, June 25, 2009 15:17, Alan Cox wrote:
> >> Which way of stopping the serial layer from grabbing the port did you
> >> have in mind?
> >
> > You can vanish it with setserial as stands. There isn't a good
> > interface for doing that from kernel side but as you can see from
> > setserial the infrastructure is all there to add it.
> 
> Seems user-unfriendly...wouldn't blacklisting that particular port (using
> ACPI or PNP id or something) be a better solution?

Possibly - what I am saying is that the mechanisms exist internally for
this including flipping a port at run time between IR and normal modes
when appropriate
