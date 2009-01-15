Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZAOCDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZAOCDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZAOCDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:03:22 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52735 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZAOCDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:03:21 -0500
Date: Thu, 15 Jan 2009 02:03:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, elendil@planet.nl,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.28] Kernel panic after closing lid on HP 2510p
Message-ID: <20090115020311.GA18740@srcf.ucam.org>
References: <200901121356.46236.elendil@planet.nl> <20090113123056.GA2464@deprecation.cyrius.com> <20090114162603.c632d82e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114162603.c632d82e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:26:03PM -0800, Andrew Morton wrote:

> It'd be a very special BIOS bug if it can reach out and make the kernel
> oops.

Lid actions typically trigger SMI code, so it's entirely capable of 
destroying CPU state in such a way that the kernel falls over (and 
probably even in ways that cause the kernel to turn green, emit pleasing 
warbling noises or invade neighbouring pieces of hardware). In this case 
it seems to be SMP specific - the system's entirely stable in UP mode. 
It's greatly vexing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
