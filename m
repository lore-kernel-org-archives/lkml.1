Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbYG3Bp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbYG3Bp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbYG3Boo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:44:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33454 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612AbYG3Bon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:44:43 -0400
Date: Wed, 30 Jul 2008 02:44:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Collins <ben.collins@canonical.com>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH 4/7] nsc-ircc: Default to dongle type 9 on IBM hardware
Message-ID: <20080730014439.GA24409@srcf.ucam.org>
References: <E1KKl4I-00068K-V7@swissweb.swissdisk.com> <1216618176.8411.124.camel@violet.holtmann.net> <1216662057.7585.153.camel@cunning> <20080728194612.01068283.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728194612.01068283.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 07:46:12PM -0700, Andrew Morton wrote:
> The changelog doesn't exist^Wexplain the reasons for this patch.
> 
> I assume it fixes some bug?  What is it?

It's necessary to set the dongle type on the nsc driver in order to get 
it to work correctly. Thinkpads all appear to use dongle type 9. This 
patch defaults nsc devices with an IBM PnP descriptor to use type 9.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
