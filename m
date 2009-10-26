Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZJZSXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZJZSXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZJZSXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:23:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56686 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZJZSXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:23:05 -0400
Date: Mon, 26 Oct 2009 18:23:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Bradbury <robert.bradbury@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: Broken ondemand scheduler in Linux 2.6.30+ on Pentium IVs
Message-ID: <20091026182304.GB4657@srcf.ucam.org>
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

...except that conservative has the same latency threshold as ondemand, 
which I'm sure wasn't supposed to be the case. I've added the cpufreq 
list to Cc:.

(Summary: p4-clockmod had its latency changed to avoid ondemand using 
it, which was done to avoid the performance impact that ondemand 
generates on p4s. I thought that conservative was still supposed to work 
here, but as it has the same latency threshold it doesn't)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
