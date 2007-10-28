Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXJ1AoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXJ1AoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 20:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXJ1AoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 20:44:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50362 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXJ1An7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 20:43:59 -0400
Message-ID: <4723DB48.60700@zytor.com>
Date: Sat, 27 Oct 2007 17:43:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>
In-Reply-To: <20071026233732.568575496@crlf.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Waychison wrote:
> The following series is meant to clean up FIBMAP paths with the eventual goal of allowing users to be able to FIBMAP their data.

Keep in mind FIBMAP is currently extremely expensive on some 
filesystems, e.g. ext3.  Therefore, additional filesystem-level work 
would have to be done in order for this not become a DoS issue.

	-hpa

