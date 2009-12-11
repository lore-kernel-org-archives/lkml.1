Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZLKQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZLKQdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZLKQda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:33:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59067 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZLKQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:33:29 -0500
Date: Fri, 11 Dec 2009 16:33:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal
	subsystem
Message-ID: <20091211163328.GA1596@srcf.ucam.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com> <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:28:37PM +0100, Luca Tettamanti wrote:
> On Fri, Dec 11, 2009 at 4:52 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > Recent Intel chipsets have support for a PCI device providing access
> > to on-board thermal monitoring. Previous versions have merely used this
> > to allow the BIOS to set trip points, but Ibex Peak documents a set of
> > registers to read values. This driver implements an hwmon interface to
> > read them.
> 
> Does it plays nice with other drivers?
> More specifically: is it possible to load the native driver and this
> one (which I presume pokes at the same chip) at the same time?

What do you mean by native driver? This is a native driver for the chip 
in question.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
