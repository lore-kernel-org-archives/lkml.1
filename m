Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYG1IKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYG1IKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYG1IKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:10:36 -0400
Received: from gw.goop.org ([64.81.55.164]:55064 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYG1IKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:10:35 -0400
Message-ID: <488D7EF9.2020500@goop.org>
Date: Mon, 28 Jul 2008 01:10:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: How to get a sense of VM pressure
References: <488A1398.7020004@goop.org> <200807261425.26318.nickpiggin@yahoo.com.au>
In-Reply-To: <200807261425.26318.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> A good start would be to register a "shrinker" (look at dcache or inode
> cache for examples). Start off by allocating pages, and slow down or
> stop or even release some of the pages back as you start getting feedback
> back through your shrinker callback.
>
> Not perfect, but it should prevent livelocks.
>   

Thanks, that's a good starting place.

    J
