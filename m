Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbYBPSmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbYBPSmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbYBPSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:41:59 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:58556 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757068AbYBPSl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:41:57 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47B72E70.1030708@am.sony.com>
Date: Sat, 16 Feb 2008 10:41:52 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
References: <47B70A61.9030306@tiscali.nl>
In-Reply-To: <47B70A61.9030306@tiscali.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2008 18:41:54.0586 (UTC) FILETIME=[9A15EFA0:01C870CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2008 08:08 AM, Roel Kluin wrote:
> The patch below was not yet tested. If it's correct as it is, please comment.

> -	if (unlikely(plug) == NO_IRQ) {
> +	if (unlikely(plug == NO_IRQ)) {

A good catch!  I'll put it in with some other 2.6.25 bug fixes.

-Geoff

