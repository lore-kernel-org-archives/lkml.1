Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYATPKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYATPKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 10:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYATPKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 10:10:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:32893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbYATPKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 10:10:04 -0500
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: update e820 instead of updating end_pfn
Date: Sun, 20 Jan 2008 16:08:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801192045.17291.yinghai.lu@sun.com> <200801200017.24445.yinghai.lu@sun.com> <20080120092027.GB8379@elte.hu>
In-Reply-To: <20080120092027.GB8379@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801201608.15401.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 January 2008 10:20:27 Ingo Molnar wrote:
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > [PATCH] x86_64: update e820 instead of updating end_pfn
> >
> > when mtrr is not covering all e820 table, need to trim the ram, need
> > to update e820
>
> ok, i like this approach even more - applied. Would you like to have a
> shot at adding mtrr_trim_uncached_memory() to 32-bit too? It is affected
> by the same problem (if not more).

What about the AMD fix I posted? You ignored that one for now but it is far 
more critical because it makes these patches break any modern AMD machine
with >3GB.

-Andi


