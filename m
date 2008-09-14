Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYINOf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYINOf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYINOfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:35:16 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:29694 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbYINOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:35:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] x86: Handle error returns in set_memory_*
Date: Sun, 14 Sep 2008 16:35:10 +0200
User-Agent: KMail/1.9.9
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, arjan@linux.intel.com,
       tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.970641000@linux-os.sc.intel.com> <20080914132742.GB554@elte.hu>
In-Reply-To: <20080914132742.GB554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809141635.12003.elendil@planet.nl>
X-OriginalArrivalTime: 14 Sep 2008 14:35:12.0487 (UTC) FILETIME=[18821F70:01C91677]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008, Ingo Molnar wrote:
> * Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> > Correctly handle the error returns from set_memory_*. We have to free
> > memtype on error return path.
>
> ah, so this is what caused the display artifacts reported by Frans Pop?

No, I have only tested with the first patch applied, not this second one.
