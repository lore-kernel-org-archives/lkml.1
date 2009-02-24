Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZBXRNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZBXRNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZBXRNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:13:07 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:33662 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbZBXRNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:13:06 -0500
From: Frans Pop <elendil@planet.nl>
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] p4-clockmod: Calculate frequency based on TSC value for P4 models 0 and 1
Date: Tue, 24 Feb 2009 18:13:00 +0100
User-Agent: KMail/1.9.9
Cc: Mattias-Christian Ott <ott@mirix.org>, Dominik Brodowski <linux@brodo.de>,
       Joerg Platte <jplatte@naasa.net>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
References: <200902240809.01312.elendil@planet.nl> <20090224165250.GB2998@redhat.com>
In-Reply-To: <20090224165250.GB2998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241813.02252.elendil@planet.nl>
X-OriginalArrivalTime: 24 Feb 2009 17:13:03.0446 (UTC) FILETIME=[26F90760:01C996A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Dave Jones wrote:
> On Tue, Feb 24, 2009 at 08:08:58AM +0100, Frans Pop wrote:
>  > From: Mattias-Christian Ott <ott@mirix.org>
>  >
>  > Commit ed9cbcd40004904dbe61ccc16d6106a7de38c998 reverted an
>  > incorrect change that resulted in random frequencies being displayed
>  > in some cases for early P4 models because the MSR_FBC_REGISTER_ID
>  > ratio is undefined.
>  >
>  > Result of the revert is that for some users the CPU frequency is
>  > displayed multiplied by a factor 8 in /proc/cpuinfo when p4-clockmod
>  > is loaded.
>  >
>  > Calculating the frequency from the TSC value should work in all
>  > cases.
>
> I already picked this up in cpufreq-next.

OK, thanks. The status of the patch was somewhat unclear as, from what I 
could see in bugzilla, it had been submitted well before the merge window 
for .29 was opened. Good to know it's in the pipeline.
