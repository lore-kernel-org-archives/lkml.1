Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYHULbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYHULbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbYHULbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:31:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50541 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbYHULbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:31:43 -0400
Date: Thu, 21 Aug 2008 12:31:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Message-ID: <20080821113141.GB3796@srcf.ucam.org>
References: <200808202106.41058.elendil@planet.nl> <200808202138.13302.rjw@sisk.pl> <200808202226.45655.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808202226.45655.elendil@planet.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 10:26:45PM +0200, Frans Pop wrote:

> The only weirdness I can see (only spotted that just now) is that both 
> cores will always seem to be changing frequency together (using ondemand 
> governor), even when 'top' shows one as idle. On my other Core Duo system 
> (an older desktop) the cores react independently.

The cores can't actually be independently scaled. Some older kernels 
would give the impression that they could, but the package itself will 
run at the greater of the defined frequencies.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
