Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbYL2OHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbYL2OHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbYL2OHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:07:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44277 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYL2OHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:07:39 -0500
Date: Mon, 29 Dec 2008 14:07:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: for.poige+linux@gmail.com, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: > I even didn't have a backtrace.
Message-ID: <20081229140728.GB31266@srcf.ucam.org>
References: <fa.q3E31Fk9IOYkDJ38/mQp9Iyp2TI@ifi.uio.no> <fa.qMGHzuTz1nuoHKywmH/aLmriclo@ifi.uio.no> <fa.LbTTdeLVGfaCxioVgNMO13Libio@ifi.uio.no> <4958C9CD.5050003@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4958C9CD.5050003@yahoo.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 12:59:57PM +0000, Sitsofe Wheeler wrote:
> Igor Podlesny wrote:
> >	Similar, but no exactly. I just thought that unlikely BIOS erases
> >memory content during "fast checks", so kernel diagnostic could be
> 
> My understanding is that the only part of the BIOS that doesn't get 
> cleared over a reboot (the hardware clock) is already being abused for 
> suspend tracing  - 
> http://mjmwired.net/kernel/Documentation/power/s2ram.txt .

That's the only part of the system that's guaranteed to persist over a 
power cycle. You probably have a little more flexibility with a warm 
reboot.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
