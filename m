Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZG3Prz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZG3Prz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZG3Pry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:47:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32971 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZG3Prx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:47:53 -0400
Date: Thu, 30 Jul 2009 11:47:34 -0400
From: Dave Jones <davej@redhat.com>
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       rusty@rustcorp.com.au, mark.langsdorf@amd.com
Subject: Re: Warning during suspend with MS-7310 mainboard
Message-ID: <20090730154734.GB2593@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	rusty@rustcorp.com.au, mark.langsdorf@amd.com
References: <1248936650.3313.6.camel@queen> <1248949671.3313.10.camel@queen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248949671.3313.10.camel@queen>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 12:27:51PM +0200, Eric Sesterhenn wrote:
 > hi,
 > 
 > bisecting was faster than expected, reverting the commit removes the warning
 > http://patchwork.kernel.org/patch/29746/

I'm just going to #ifdef __powerpc__ the suspend/resume paths of cpufreq
today, because I'm tired of seeing reports of this bug.

	Dave

