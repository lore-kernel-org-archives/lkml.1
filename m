Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZBRSg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZBRSg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZBRSgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:36:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47098 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZBRSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:36:46 -0500
Date: Wed, 18 Feb 2009 18:36:41 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090218183641.GA20203@srcf.ucam.org>
References: <20090218182822.GA19902@srcf.ucam.org> <20090218183137.GD26802@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218183137.GD26802@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:

> Nice fix! Where does this information come from? Distro module 
> ordering magic? It's rather non-trivial.

Pretty much. p4-clockmod is never the preferred option because it does 
no voltage scaling. speedstep-centrino is now almost entirely 
functionally replaced with acpi-cpufreq. The powernow-k8 issue was a 
personal communication from davej.

> (small style nit: the first line in the Makefile is overlong.)

Seems to be 79 characters?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
