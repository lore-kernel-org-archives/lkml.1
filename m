Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbXLZRtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbXLZRtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 12:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXLZRs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 12:48:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXLZRs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 12:48:56 -0500
Message-ID: <477293F3.60304@zytor.com>
Date: Wed, 26 Dec 2007 09:48:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
References: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk>
In-Reply-To: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The functions time_before, time_before_eq, time_after, and time_after_eq
> are more robust for comparing jiffies against other values.
> 

More robust, how?  You already almost introduced a bug here...

	-hpa
