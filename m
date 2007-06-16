Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbXFPAzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbXFPAzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXFPAzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:55:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXFPAzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:55:46 -0400
Date: Fri, 15 Jun 2007 20:54:28 -0400
From: Dave Jones <davej@redhat.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk, tiwai@suse.de
Subject: Re: [BUG] Interesting race between cpufreq_ondemand and snd_atiixp
Message-ID: <20070616005428.GG23417@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
	linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk,
	tiwai@suse.de
References: <200706160233.47659.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706160233.47659.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 02:33:41AM +0300, S.Çağlar Onur wrote:

 > One of our colleagues found following problem with his old laptop while 
 > testing Linus's latest git with external alsa-driver (v1.0.14). And we can 
 > also reproduce same problem with 2.6.18.8 so it seems not a new regression 
 > (if it is a regression).
 > 
 > As a summary "sound stops to work if cpufreq_ondemand governor is used" on 
 > that laptop. Problem occurs only if cpufreq_* modules are loaded and %100 
 > reproducable if system configured for ondemand governor. 

I'm puzzled.  The cpuinfo shows that this cpu doesn't have speedstep, so
why acpi-cpufreq successfully loads is a mystery.

What's in/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies  ?

Maybe the acpi implementation is faking multiple speeds using throttling
a la p4-clockmod, which would be a bit loopy, but possible I guess.

	Dave

-- 
http://www.codemonkey.org.uk
