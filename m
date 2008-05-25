Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYEYPJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYEYPJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYEYPIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:08:52 -0400
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:51892 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbYEYPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:08:51 -0400
From: Frans Pop <elendil@planet.nl>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Sun, 25 May 2008 17:08:47 +0200
User-Agent: KMail/1.9.9
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200805022122.03576.elendil@planet.nl> <200805051932.41827.elendil@planet.nl> <20080506224240.GA18706@linux-os.sc.intel.com>
In-Reply-To: <20080506224240.GA18706@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251708.49038.elendil@planet.nl>
X-OriginalArrivalTime: 25 May 2008 15:08:49.0905 (UTC) FILETIME=[3CB7AE10:01C8BE79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2008, Venki Pallipadi wrote:
> On Mon, May 05, 2008 at 07:32:40PM +0200, Frans Pop wrote:
> > Note that the "expected mapping type" errors remain the same both with
> > and without framebuffer console.
>
> The patch below plugs the mprotect hole and should eliminate the
> "expected mapping type" error messages. Can you check.

Hi,

My apologies for the very late reply. Unfortunately I've had no time for 
work on kernel issues the last few weeks.

I have not specifically tested any of the proposed patches, but I can 
confirm that the "expected mapping type" errors are gone with -rc2 
and -rc3. Thanks a lot.

The artifacts are still there though and frequently even worse than 
originally reported. I will open a bugzilla entry for that.

Cheers,
FJP
