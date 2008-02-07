Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYBGHSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYBGHSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYBGHSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:18:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:36679 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbYBGHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XIyyWS9AfXl+dOLt0m3iqv7SxmRzDs9X6gfz0J8dQ6o28GS+WGW3DpvpsCV9xgmBVOIIaBAt7MybGRzDvE2q02t1wah/Cnor1M3swhbpgTNcycxMStD5BPxgvYuHPfomhBuPmgFYDAijeN33WWXoSXHhI02z0AJ4jmi730ZvvlA=
Subject: Re: [PATCH 1/3] x86: sparse warning in cpufreq/powernow-k8.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080207043547.GA10078@codemonkey.org.uk>
References: <1202342867.5820.89.camel@brick>
	 <20080207043547.GA10078@codemonkey.org.uk>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 23:18:16 -0800
Message-Id: <1202368696.22452.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-06 at 23:35 -0500, Dave Jones wrote:
> On Wed, Feb 06, 2008 at 04:07:47PM -0800, Harvey Harrison wrote:
>  > Nested per_cpu accessors will shadow the internal __ptr variable.  Use
>  > a temporary first_core variable.
>  > 
>  > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1239:9: warning: symbol '__ptr' shadows an earlier one
>  > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1239:9: originally declared here
>  > 
>  > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Already fixed in cpufreq.git
> 
> (Please also Cc me on cpufreq patches, thanks)
> 

Sorry about that, I've been sending Ingo a bunch of x86 patches, didn't
think to look further than that.  Will keep in mind.

Harvey

