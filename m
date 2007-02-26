Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbXBZHzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbXBZHzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933793AbXBZHzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:55:36 -0500
Received: from terminus.zytor.com ([192.83.249.54]:58699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755AbXBZHzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:55:35 -0500
Message-ID: <45E2926C.40009@zytor.com>
Date: Sun, 25 Feb 2007 23:55:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Remove redundant #ifdef __KERNEL__ checks.
References: <Pine.LNX.4.64.0702251509440.27758@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0702251509440.27758@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   Remove the redundant intermediate checks for __KERNEL__ since, as
> soon as one ends, the next one starts.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 

However, what's much worse is that this already has put series of 
constants which are part of the ABI under __KERNEL__.  This is a very 
bad thing.

	-hpa
