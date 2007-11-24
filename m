Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXKXR5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXKXR5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXKXR5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:57:01 -0500
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:28288 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbXKXR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:56:59 -0500
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Cc: linux-kernel@vger.kernel.org, mb@bu3sch.de, mingo@elte.hu
In-reply-To: <20071124175112.58193424@morte>
References: <20071124175112.58193424@morte>
Message-Id: <E1IvzFR-0001am-3J@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sat, 24 Nov 2007 18:56:57 +0100
X-OriginalArrivalTime: 24 Nov 2007 17:56:57.0073 (UTC) FILETIME=[678B1E10:01C82EC3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Brivio wrote:
> It looks like the jiffies counter sometimes jumps back and forth of some
> hundreds seconds in 2.6.24-rc3. I observed that this happens when I use
> the su(1) command, e.g.:

Can you please explain what exactly the problem is here?

Are you perhaps referring to the number between square brackets for the su
log lines? In that case there is no problem as in that case the number is
not jiffies, but the process ID (PID) of the su process...

Cheers,
FJP
