Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZHRMK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZHRMK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbZHRMKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:10:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49838 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZHRMKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:10:54 -0400
Date: Tue, 18 Aug 2009 13:10:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Dell-laptop is not working without wireless
Message-ID: <20090818121049.GB22284@srcf.ucam.org>
References: <20090818060340.E1C7A526EA5@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818060340.E1C7A526EA5@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 10:32:27PM -0700, Dmitry Torokhov wrote:

> dell-laptop module does not work on my Latitude d630 unless driver for
> my wireless card (which happens to be iwl3945) is already loaded.
> Otherwise dcsbas_smi_request() returns all zeroes which causes
> dell-laptop to not create any rfkill devices nor install backlight
> device:

That's quite bizarre. I'd had one report of the backlight setup failing, 
but hadn't connected it with wireless driver loading. Long shot, but I 
don't suppose you can figure out which bit of the wifi config is needed 
to get dell-laptop working by just bailing at various bits of the probe 
and seeing if you get sensible answers?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
