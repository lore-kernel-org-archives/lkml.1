Return-Path: <linux-kernel-owner+w=401wt.eu-S1764730AbYDVRdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764730AbYDVRdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763610AbYDVRae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:30:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763683AbYDVRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:30:31 -0400
Date: Tue, 22 Apr 2008 10:29:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
In-Reply-To: <20080422171324.GP12774@kernel.dk>
Message-ID: <alpine.LFD.1.10.0804221027210.2779@woody.linux-foundation.org>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804220735350.2779@woody.linux-foundation.org> <20080422145105.GJ12774@kernel.dk>
 <alpine.LFD.1.10.0804220759020.2779@woody.linux-foundation.org> <20080422164947.GN12774@kernel.dk> <20080422170405.GO12774@kernel.dk> <20080422171324.GP12774@kernel.dk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jens Axboe wrote:
> 
> But wait, falling back to wait cannot always be safe if we are called
> with interrupts disabled. I don't see any way around using the global
> fallback for that case.

Hmm. Good point. It does look like you need three cases.

		Linus
