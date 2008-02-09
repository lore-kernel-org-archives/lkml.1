Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYBIAda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYBIAda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYBIAdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:33:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46875 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYBIAdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:33:23 -0500
Message-ID: <47ACF488.7070502@zytor.com>
Date: Fri, 08 Feb 2008 16:32:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802082301.51582.rjw@sisk.pl> <20080208220834.GA1631@elf.ucw.cz> <200802090118.50418.rjw@sisk.pl>
In-Reply-To: <200802090118.50418.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> Consolidated patch is appended.  I'll test it tomorrow on x86-64.
> 
> I'd like to add the cleaned up beeping code to it and perhaps try to push it
> for -mm testing without any further changes.  We can still do more cleanups in
> followup patches.
> 

The other thing to figure out is to what extent we can clean up the 
conditionals in the video mode code by refactoring.  All they really do 
here is save space by removing functionality not needed for wakeup, 
because I didn't know how much space was realistic.

It's possible we can remove them altogether by having a dummy 
boot_params structure (4K).

	-hpa
