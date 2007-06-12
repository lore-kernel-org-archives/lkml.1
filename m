Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbXFLJOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbXFLJOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXFLJOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:14:35 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:45914 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXFLJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:14:34 -0400
Date: Tue, 12 Jun 2007 10:14:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       andi@rhlx01.fht-esslingen.de, Keith Packard <keithp@keithp.com>
Message-ID: <20070612091427.GB9719@srcf.ucam.org>
References: <20070612015459.GB28668@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612015459.GB28668@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC][AGPGART]intel-agp: save whole config space in suspend/resume
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 09:54:59AM +0800, Wang Zhenyu wrote:

> +		for (i = 0; i < 48; i++) {

You seem to be writing the base address after the aperture size? That 
won't work. As Dave says, there are ordering contraints.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
