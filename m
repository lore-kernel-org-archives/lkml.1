Return-Path: <linux-kernel-owner+w=401wt.eu-S1764157AbYFKQqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764157AbYFKQqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYFKQqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:46:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYFKQqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:46:24 -0400
Message-ID: <485000E7.80408@zytor.com>
Date: Wed, 11 Jun 2008 09:44:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] x86: enable PAT on (almost) all CPUs that advertise it
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl> <484F0F5D.8010507@zytor.com> <20080611094730.GB5889@alberich.amd.com> <20080611150507.GD5170@alberich.amd.com>
In-Reply-To: <20080611150507.GD5170@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> 
> I just kept the "whitelist" for Intel CPUs. It is similar to what was
> submitted by Venkatesh in the first place.
> See pat_known_cpu() in commit 2e5d9c857d4e6c9e7b7d8c8c86a68a7842d213d6
> (x86: PAT infrastructure patch).
> 

Yes, but the "whitelist" for Intel CPUs cover all CPUs which ever 
flagged the PAT bit, so it should be nuked, too.

	-hpa
