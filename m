Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZJZSTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZJZSTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZJZSTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:19:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56638 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZJZSTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:19:34 -0400
Date: Mon, 26 Oct 2009 18:19:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Bradbury <robert.bradbury@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Broken ondemand scheduler in Linux 2.6.30+ on Pentium IVs
Message-ID: <20091026181934.GA4657@srcf.ucam.org>
References: <deaa866a0910251546m7ea001bcm252c41e65927a424@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deaa866a0910251546m7ea001bcm252c41e65927a424@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ondemand governor assumes that frequency transitions occur at low 
latency. This isn't usefully the case with p4-clockmod, and running 
ondemand there will generally show obvious performance regressions. If 
you have a recent enough P4 use the acpi-cpufreq driver instead. If not, 
the conservative governor should still work and is a better fit to the 
hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
