Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYFRJ5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYFRJ5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYFRJ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:56:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35718 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYFRJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:56:51 -0400
Date: Wed, 18 Jun 2008 10:56:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, trenn@suse.de
Subject: Re: [Patch v2] Implement thermal limiting in the generic thermal class
Message-ID: <20080618095646.GA20079@srcf.ucam.org>
References: <20080611100647.GA20013@srcf.ucam.org> <20080616085544.GA17813@srcf.ucam.org> <20080616092648.GA18506@srcf.ucam.org> <20080617185345.GA5847@ucw.cz> <823A93EED437D048963A3697DB0E35DE0171191C@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <823A93EED437D048963A3697DB0E35DE0171191C@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 05:28:01PM +0800, Zhang, Rui wrote:
> One thing I'm concerning is that if we could enable polling in Linux.
> Bug #8842 shows that polling may break some laptops.
> And we have known that windows never enable polling.
> Although this patch will not break the laptop in #8842, it still may
> bring some potential risks if we enable polling in Linux.
> IMO, a dmi entry would be much more acceptable...

If it breaks anything, we can revisit the decision. I'd be surprised if 
it did.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
