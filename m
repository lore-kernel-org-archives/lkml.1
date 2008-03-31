Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbYCaV6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbYCaV6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbYCaV6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:58:08 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:7041 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYCaV6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:58:07 -0400
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert i386
References: <20080331171506.GA24017@mailshack.com>
	<20080331102240.086a93e4@extreme>
	<20080331193830.GA24156@mailshack.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 Mar 2008 23:58:02 +0200
In-Reply-To: <20080331193830.GA24156@mailshack.com>
Message-ID: <87d4pa1rpx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Mar 2008 21:51:23.0147 (UTC) FILETIME=[5C73ADB0:01C89379]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum <heukelum@mailshack.com> writes:
> 
> bitmap <- [0...]
> for bitmapsize=1 to 512
> 	for bitposition=0 to bitmapsize-1

I don't think that's a useful benchmark because you're testing 
mostly values that a real kernel will never use.

-Andi
