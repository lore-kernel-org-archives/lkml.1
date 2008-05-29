Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYE2Tqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYE2Tqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYE2Tqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:46:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYE2Tqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:46:39 -0400
Date: Thu, 29 May 2008 12:46:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
In-Reply-To: <20080529193813.4bc0a677@core>
Message-ID: <alpine.LFD.1.10.0805291245330.2958@woody.linux-foundation.org>
References: <20080529161453.24735.805.stgit@core> <alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org> <20080529190235.258d304e@core> <483EF536.90801@garzik.org> <20080529193813.4bc0a677@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, Alan Cox wrote:
> 
> I did check them all and review them and read the documentation right
> back to the original 1010 controller behaviour. I stand by my comment.

Your comment is pointless.

The old function oopsed for the case that you worry about. That is WORSE 
than anything else you can come up with. There is absolutely zero upside 
to using that old and broken thing.

		Linus
