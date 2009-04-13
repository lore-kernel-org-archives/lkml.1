Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZDMOud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZDMOud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZDMOuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:50:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44213 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZDMOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:50:22 -0400
Date: Mon, 13 Apr 2009 15:50:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
Message-ID: <20090413145015.GA10976@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org> <200904112150.38010.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904112150.38010.elendil@planet.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 09:50:35PM +0200, Frans Pop wrote:
> Matthew Garrett wrote:
> > Calling the ENAB method on Toshiba laptops results in notifications
> > being sent when laptop hotkeys are pressed. This patch simply calls that
> > method and sets up an input device if it's successful.
> 
> Hi Matthew,
> 
> On my Satellite A40-241 the patch works fine for the Fn keys, but it does 
> not work for the multimedia keys next to the power button. No event is 
> generated (I tested this by directly reading the /dev/input/eventX file).
> 
> Any chance those could be made to work too?

Can you send me the acpidump?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
