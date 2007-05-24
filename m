Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbXEXWmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbXEXWmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXEXWmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:42:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbXEXWmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:42:02 -0400
Date: Thu, 24 May 2007 18:41:54 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524224154.GA29337@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>,
	Len Brown <len.brown@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@suse.de>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org> <46560E4F.2080009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46560E4F.2080009@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 03:14:39PM -0700, H. Peter Anvin wrote:

 > pbe collides with abuse by at least two vendors (AMD and
 > Cyrix/Centaur/VIA) of this bit for 3DNow.

Unless I'm mistaken,

pbe comes from cpuid level 1

3dnow comes from cpuid level 0x80000001
though I did notice that amd have it in edx, whilst via have it in ecx
curiously.

	Dave

-- 
http://www.codemonkey.org.uk
