Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbYBGXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbYBGXm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYBGXms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:42:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbYBGXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:42:47 -0500
Message-ID: <47AB975C.1010902@zytor.com>
Date: Thu, 07 Feb 2008 15:42:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <47AB887E.7010000@zytor.com> <200802080006.54151.rjw@sisk.pl> <20080207233509.GB21468@elf.ucw.cz>
In-Reply-To: <20080207233509.GB21468@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> I really need the entry point to be at offset 0, so that I can get
> pointers to my data. I could not figure out how to do it any other
> way. And if 0 is taken, I thought I'd put header at the end.
> 

Why not just put the structure at 0, and put pointers in the structure 
to everything else you need?

	-hpa
