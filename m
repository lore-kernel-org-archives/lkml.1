Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZBYDyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZBYDyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 22:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZBYDx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 22:53:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41543 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbZBYDx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 22:53:56 -0500
Date: Tue, 24 Feb 2009 22:53:36 -0500
From: Dave Jones <davej@redhat.com>
To: Frans Pop <elendil@planet.nl>, Mattias-Christian Ott <ott@mirix.org>,
       Dominik Brodowski <linux@brodo.de>, Joerg Platte <jplatte@naasa.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] p4-clockmod: Calculate frequency based on TSC value
	for P4 models 0 and 1
Message-ID: <20090225035336.GB25446@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frans Pop <elendil@planet.nl>,
	Mattias-Christian Ott <ott@mirix.org>,
	Dominik Brodowski <linux@brodo.de>,
	Joerg Platte <jplatte@naasa.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	cpufreq@vger.kernel.org
References: <200902240809.01312.elendil@planet.nl> <20090224165250.GB2998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224165250.GB2998@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 11:52:50AM -0500, Dave Jones wrote:
 
 > I already picked this up in cpufreq-next. 
 > Additionally, it needs the chunk below.

nggh, it also needs the ifdef X86_32 guards around recalibrate_cpu_khz removed
or it still fails allmodconfig on 64bit.

	Dave

-- 
http://www.codemonkey.org.uk
