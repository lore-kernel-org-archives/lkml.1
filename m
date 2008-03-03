Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbYCCVGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbYCCVGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYCCVGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:06:35 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:49205 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761509AbYCCVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:06:35 -0500
Date: Mon, 3 Mar 2008 21:06:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Klaus S. Madsen" <ksm@hjernemadsen.org>, Ingo Molnar <mingo@elte.hu>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20080303210607.GA24833@srcf.ucam.org>
References: <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080303210526.GI13869@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303210526.GI13869@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:05:26PM +0100, Pavel Machek wrote:

> I do not have NX capable CPU in machine using for suspend
> testing. ... and you are using 32-bit userspace on 64-bit kernel,
> right?

Not if he's expecting vm86 to work...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
