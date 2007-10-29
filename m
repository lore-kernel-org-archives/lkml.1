Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXJ2CxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXJ2CxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJ2Cwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:52:53 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:48223 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXJ2Cww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:52:52 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
Date: Sun, 28 Oct 2007 20:50:33 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: trenn@suse.de, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
References: <1193236319.4590.225.camel@queen.suse.de> <200710250906.23003.bjorn.helgaas@hp.com> <20071027150947.GA1568@srcf.ucam.org>
In-Reply-To: <20071027150947.GA1568@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710282050.34166.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007 9:09:47 am Matthew Garrett wrote:
> On Thu, Oct 25, 2007 at 09:06:22AM -0600, Bjorn Helgaas wrote:
> > But we really *should* reserve things used by opregions, shouldn't
> > we?  After all, the whole point of resource reservation is to prevent
> > conflicts.
>
> Only if you're happy to lose functionality like IDE, sadly.

That's a simplistic answer to a complex problem.  I don't think
we should just ignore the whole problem, cross our fingers, and
hope that firmware stays out of our way.

Bjorn
