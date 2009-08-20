Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZHTTeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZHTTeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZHTTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:34:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:36872 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZHTTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:34:04 -0400
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
From: David Woodhouse <dwmw2@infradead.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0908201229o6ba670ebqda4d7cfc72d0ece8@mail.gmail.com>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
	 <20090819142634.0fc550d1.akpm@linux-foundation.org>
	 <1250754748.8974.17.camel@macbook.infradead.org>
	 <1250755318.8974.26.camel@macbook.infradead.org>
	 <2c0942db0908201229o6ba670ebqda4d7cfc72d0ece8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 20:32:20 +0100
Message-Id: <1250796740.3311.2.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 12:29 -0700, Ray Lee wrote:
> Think about changing this to a warning that "Your IOMMU appears to be
> disabled." All ones is, after all, the traditional hint that the
> device is turned off.

Hints are all very well, but the BIOS provided an ACPI table explicitly
telling us that there was an active IOMMU at this location.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

