Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYKJR37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYKJR37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYKJR3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:29:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60253 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbYKJR3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:29:50 -0500
Date: Mon, 10 Nov 2008 17:29:46 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ACPI crash on lid close - SMP race?
Message-ID: <20081110172946.GA3512@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org> <1226337995.5292.25.camel@segulix.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226337995.5292.25.camel@segulix.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 05:26:35PM +0000, Sergio Monteiro Basto wrote:
> Hi, About this _DOS , I reported this problem a long time ago, which now
> is on http://bugzilla.kernel.org/show_bug.cgi?id=6001
> Could you put yours comment on it ? 
> 
> On fedora stock kernel, appears one patch, (Now I see that you are the
> author :) ) 
> 
> I tested your patch and it works for me ! 

Yeah, that's the "safe" patch which stops us executing the codepath that 
breaks, but also means I don't get display switch events. Having it set 
to 1 means executing BIOS code that's likely to interfere with the rest 
of the system, so a crash isn't surprising. But a setting of 0 *should* 
be safe, and I'm quite confused as to why it's exploding.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
