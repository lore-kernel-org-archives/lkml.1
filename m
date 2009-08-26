Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZHZQZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZHZQZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZHZQZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:25:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46988 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZHZQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:25:43 -0400
Date: Wed, 26 Aug 2009 17:25:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 5/6] thermal: Only set passive_delay for forced passive
	cooling
Message-ID: <20090826162537.GC15868@srcf.ucam.org>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251303445-25317-6-git-send-email-elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251303445-25317-6-git-send-email-elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 06:17:24PM +0200, Frans Pop wrote:
> Setting polling_delay is useless as passive_delay has priority,
> so the value shown in proc isn't the actual polling delay. It
> also gives the impression to the user that he can change the
> polling interval through proc, while in fact he can't.
> 
> Also, unset passive_delay when the forced passive trip point is
> unbound to allow polling to be disabled.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Zhang Rui <rui.zhang@intel.com>

I'll look over this - I seem to remember having some reason to set that, 
but it escapes me now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
