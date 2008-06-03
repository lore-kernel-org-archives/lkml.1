Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYFCSOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYFCSOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYFCSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:13:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44693 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbYFCSNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:13:54 -0400
Date: Tue, 3 Jun 2008 19:13:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080603181346.GA5013@srcf.ucam.org>
References: <20080528143857.GB5585@homac.suse.de> <4845886E.2010505@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4845886E.2010505@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 02:07:42PM -0400, Jeff Garzik wrote:

> It would be nice if you and Holger could work together to produce a 
> single patch[set]...  right now I have patches from both of you, and I 
> was sorta waiting on the thread to die down to see if competing patches 
> might merge into a single set

I think we were waiting for feedback from Tejun as to why removing the 
port freeze call fixed the hang I was seeing? Beyond that, Holger's 
latest patch looked good to me.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
