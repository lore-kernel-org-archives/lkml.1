Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbXJaNon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbXJaNon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbXJaNod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:44:33 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:37659 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbXJaNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=Nw1U7d553sanhaXr+MuS1dHHiCUiSYjkjgsWn7dHxEig39DvdEKm3XOthhJX9UsY8J/xv+ijQjDM74B6SQ8uRCRr/AyD3kbqoiWxzpWv8m89aNX0Ujugfp5m3PoBpWeeZ13xMDUOCnllWkWoDTHyBwtYBuaUqeAE+hU32G7LsLs=
Message-ID: <472886B2.1060207@gmail.com>
Date: Wed, 31 Oct 2007 09:44:18 -0400
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jeff Garzik <jeff@garzik.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/33] Swap over NFS -v14
References: <20071030160401.296770000@chello.nl>	 <200710311426.33223.nickpiggin@yahoo.com.au>	 <1193830033.27652.159.camel@twins>  <47287220.8050804@garzik.org> <1193835413.27652.205.camel@twins>
In-Reply-To: <1193835413.27652.205.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> 
> But please, people who want this (I'm sure some of you are reading) do
> speak up. I'm just the motivated corporate drone implementing the
> feature :-)

FWIW, I could have used a "swap to network technology X" like system at
my last job.  We were building a large networking switch with blades,
and the IO cards didn't have anywhere near the resources that the
control modules had (no persistent storage, small ram, etc).  We were
already doing userspace coredumps over NFS to the control cards.  It
would have been nice to swap as well.

