Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbXIQJJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbXIQJJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXIQIke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:40:34 -0400
Received: from mx1.suse.de ([195.135.220.2]:53763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbXIQIkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:40:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [RFC -mm 0/2] i386/x86_64 boot: 32-bit boot protocol
Date: Mon, 17 Sep 2007 10:40:26 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1190017572.5866.20.camel@caritas-dev.intel.com>
In-Reply-To: <1190017572.5866.20.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709171040.27043.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2007 10:26:12 Huang, Ying wrote:
> For machine with some new BIOS other than legacy BIOS, such as EFI,
> LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
> based on legacy BIOS can not be used, so a 32-bit boot protocol need
> to be defined.

The patch doesn't seem to be what you advertise in the description.
Can you start with a patch that just implements the new boot protocol
parsing for better review? The EFI code should be all in separate 
patches.
-Andi
