Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYFCHAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYFCHAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYFCHAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:00:31 -0400
Received: from mail2.shareable.org ([80.68.89.115]:45486 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYFCHAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:00:30 -0400
Date: Tue, 3 Jun 2008 08:00:16 +0100
From: Jamie Lokier <jamie@shareable.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset translation
Message-ID: <20080603070016.GA23429@shareable.org>
References: <48447615.5050806@am.sony.com> <48449FAE.70404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48449FAE.70404@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Tim Bird wrote:
> >With CONSOLE_TRANSLATIONS turned off, this saves about 6K
> >on my kernel configured for an ARM development board (OMAP
> >5912 OSK).  In embedded products I'm familiar with,
> >console translations are not needed.
> 
> On most embedded products I'm familiar with, you wouldn't have virtual 
> consoles at all...?

On anything with a framebuffer, VCs are quite handy for debugging.
Saving 6k won't save the world on those devices, but each little bit
helps - especially due to no-MMU fragmentation.

-- Jamie
