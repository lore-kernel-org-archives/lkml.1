Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbXHPOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbXHPOIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbXHPOIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:08:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54588 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066AbXHPOIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:08:39 -0400
Date: Thu, 16 Aug 2007 19:51:22 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andy Whitcroft <apw@shadowen.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 0/6] checkpatch checks for trailing semicolons on
 conditionals
In-Reply-To: <exportbomb.1187270320@pinky>
Message-ID: <alpine.LFD.0.999.0708161943560.25951@enigma.security.iitk.ac.in>
References: <exportbomb.1187270320@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Aug 2007, Andy Whitcroft wrote:

> A couple of people suggested adding checks to checkpatch for trailing
> semicolons on conditionals, where the conditional block may not be
> actually conditional:
> 
> 	if (err);
> 		return err;
> 
> While regression testing the changes, I ran these checks across the
> whole of 2.6.23-rc3 and there appear to be 5 places where this is
> occurs (above and beyond the IPv6 one which triggered this effort)
> and a benign use which could be confused later which it seems safest
> to fix.
> 
> Following this email are 6 patches for these issues, relevant
> maintainers cc'd.  All against 2.6.23-rc3

Amazing :-) All 6 obviously correct, and one of those 5 bugs was around
for more than ~2 years! But most of these made one wonder (sadly) about
the (lack of) testing code got before getting merged, considering some
(#2 and 6, at least) should've been obvious immediately on basic testing
of the new feature, I think.
