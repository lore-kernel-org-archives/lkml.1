Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZDFPGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZDFPGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZDFPG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:06:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbZDFPG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:06:28 -0400
Date: Mon, 6 Apr 2009 08:04:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Message-ID: <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Jens Axboe wrote:
> 
> This is a set of patches that I worked on today in the hopes
> of furthering the latency goals and at least fixing some of
> the write regression with fwrite + fsync that current -git
> is suffering from.

Goodie. Let's just do this. After all, right now we would otherwise have 
to revert the other changes as being a regression, and I absolutely _love_ 
the fact that we're actually finally getting somewhere on this fsync 
latency issue that has been with us for so long.

Jens - I can just apply this queue (I want to test it out anyway), or if 
you prefer I can pull from you. Just tell me.

		Linus
