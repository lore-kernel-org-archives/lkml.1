Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYBQQoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYBQQoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYBQQo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:44:29 -0500
Received: from iabervon.org ([66.92.72.58]:57726 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYBQQo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:44:28 -0500
Date: Sun, 17 Feb 2008 11:44:27 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 2.6.23] no vga console and no messages
In-Reply-To: <E1JQe5R-0001cW-1a@faramir.fjphome.nl>
Message-ID: <alpine.LNX.1.00.0802171134350.5496@iabervon.org>
References: <alpine.LNX.1.00.0802162042130.6093@iabervon.org> <E1JQe5R-0001cW-1a@faramir.fjphome.nl>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Frans Pop wrote:

> Daniel Barkalow wrote:
> > For some reason I can't see and don't know how to debug, in 2.6.23 on my
> > server I don't get the vga console, but only get the dummy console.
> 
> Please check if this bug report matches the issue you are seeing:
> http://bugzilla.kernel.org/show_bug.cgi?id=9310

I think mine might be different. I've got a vga parameter (vga=0x301), and 
mine disappears very early, before when you usually get "Console: 
colour VGA+ 80x25" (and I'm getting "Console: coloud dummy 80x25" 
instead). I've also got CONFIG_FB turned off entirely.

But if you've got any insight into how the console driver stuff works from 
troubleshooting your problem, I could use the hints...

	-Daniel
*This .sig left intentionally blank*
