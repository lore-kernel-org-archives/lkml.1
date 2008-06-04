Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYFDBWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYFDBWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYFDBWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:22:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42032 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYFDBWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:22:06 -0400
Date: Wed, 4 Jun 2008 02:21:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Jones <davej@codemonkey.org.uk>, maximilian attems <max@stro.at>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       cking <colin.king@canonical.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] Enable speedstep for sonoma processors.
Message-ID: <20080604012158.GA12806@srcf.ucam.org>
References: <1212512656-13462-1-git-send-email-max@stro.at> <20080603174218.GA15293@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603174218.GA15293@codemonkey.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:42:18PM -0400, Dave Jones wrote:

> This patch has been floating around for years.
> So long, I've forgotten the original reason it wasn't accepted.
> It had something to do with it working for some users, but not others,
> and we can't detect the 'not working' case.

My recollection is that we had no way to work out which voltage table 
was appropriate for a given CPU, so there was a risk of us either over- 
or under-volting the chip. Doing it via ACPI is safe.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
