Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbXL2EwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbXL2EwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbXL2EwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:52:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbXL2EwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:52:11 -0500
Message-ID: <4775D276.7040301@zytor.com>
Date: Fri, 28 Dec 2007 20:52:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jonathan Lim <jlim@sgi.com>
CC: linux-kernel@vger.kernel.org, jlan@sgi.com
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
References: <200712282126.lBSLQ76K042714@sabah.engr.sgi.com>
In-Reply-To: <200712282126.lBSLQ76K042714@sabah.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Lim wrote:
> It's possible that the values used in and returned from jiffies_to_usecs() are
> incorrect because of truncation when variables of type u64 are involved.  So a
> function specific to that type is used instead.

Much worse than that.  There are internal overflows in the conversions. 
See the patch I recently submitted to -mm.

	-hpa
