Return-Path: <linux-kernel-owner+w=401wt.eu-S1422686AbXCBBXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422686AbXCBBXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422684AbXCBBXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:23:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422679AbXCBBXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:23:51 -0500
Date: Thu, 1 Mar 2007 17:24:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jgarzik@pobox.com
Subject: Re: [PATCH] libata: Cable detection fixes
In-Reply-To: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0703011723270.12485@woody.linux-foundation.org>
References: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Mar 2007, Alan wrote:
>
> The patch switches the identify order so that we can do the drive side
> detection correctly. 
> 
> Secondly we add a ->cable_detect() method called after the identify
> sequence which allows a host to do host side detection at this point
> should it wish, or to modify the results of the drive side identify.

Alan, sign-offs?

Jeff, should I just expect to get these things through you?

		Linus
