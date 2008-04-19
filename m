Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYDST6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYDST6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 15:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYDST6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 15:58:36 -0400
Received: from 1wt.eu ([62.212.114.60]:3202 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbYDST6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 15:58:36 -0400
Date: Sat, 19 Apr 2008 21:44:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.36.3
Message-ID: <20080419194438.GA16133@1wt.eu>
References: <20080419145327.GA23566@hera.kernel.org> <480A4693.3050208@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480A4693.3050208@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sat, Apr 19, 2008 at 03:22:59PM -0400, H. Peter Anvin wrote:
> Any reason to have 2.4.x.y instead of just 2.4.x+y?  I find it somewhat 
> hard to believe there is substantial new development on 2.4, so it 
> really should be all "stable".

Since 2.4.33 there have been a few minor add-ons and backports (support
for gcc4, e1000 update, and mmap_min_addr come to mind). It's important
for me to indicate when users can blindly upgrade (eg: security fix or
real bug) and when they should at least perform a quick revalidation.

This has worked well for quite some time now. Since the changes were
really minor here, I did not want to open 2.4.37 with just that. Maybe
there will be no 2.4.37, maybe I'll open it if I gather several significant
driver/arch updates or build fixes (eg: gcc is not supported beyond 4.1
right now).

Regards,
Willy

