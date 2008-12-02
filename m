Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYLBQPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYLBQPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYLBQPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:15:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36540 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYLBQPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:15:30 -0500
Date: Tue, 2 Dec 2008 16:15:21 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Message-ID: <20081202161520.GA18252@srcf.ucam.org>
References: <1227454026.7262.59.camel@localhost> <20081123180409.GB7731@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123180409.GB7731@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 07:04:09PM +0100, Pavel Machek wrote:

> Is this really needed? Could we simply talk to the cpu directly,
> without help of ACPI?

No. The ACPI write ends up talking to the embedded controller and some 
io ports.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
