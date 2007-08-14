Return-Path: <linux-kernel-owner+w=401wt.eu-S937153AbXHNXAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937153AbXHNXAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936923AbXHNXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:00:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53666 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937018AbXHNXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:00:19 -0400
Date: Wed, 15 Aug 2007 04:43:02 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Tim Bird <tim.bird@am.sony.com>
cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <46C233CB.9000602@am.sony.com>
Message-ID: <alpine.LFD.0.999.0708150442010.6482@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Aug 2007, Tim Bird wrote:

> Hi all,
> 
> I have a quick question.
> 
> I'm trying to resurrect a patch from the Linux-tiny patch suite,
> to do accounting of kmalloc memory allocations.  In testing it
> with Linux 2.6.22, I've found a large number of kfrees of
> NULL pointers.
> 
> Is this considered OK?

kfree(NULL) is allowed -- for programmers' convenience.
