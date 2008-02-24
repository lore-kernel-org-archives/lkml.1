Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYBXSxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYBXSxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYBXSwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:52:53 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:53391 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbYBXSww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:52:52 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <47C1BC31.9070402@am.sony.com>
Date: Sun, 24 Feb 2008 10:49:21 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Samuel Tardieu <sam@rfc1149.net>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH] ps3: Fix "unlikely" incorrect usage
References: <20080224081037.D492320AFF@arrakis.enst.fr>
In-Reply-To: <20080224081037.D492320AFF@arrakis.enst.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2008 18:49:24.0508 (UTC) FILETIME=[F99095C0:01C87715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2008 12:06 AM, Samuel Tardieu wrote:
> Fix unlikely(plug) == NO_IRQ into unlikely(plug == NO_IRQ).
> 
> Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
> ---
>  arch/powerpc/platforms/ps3/interrupt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Thanks for the submission, but this fix is already in
ps3-linux.git.  I was waiting to collect a few other bugs
before sending it to Paul.

-Geoff

