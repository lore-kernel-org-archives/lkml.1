Return-Path: <linux-kernel-owner+w=401wt.eu-S965995AbXCPWf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965995AbXCPWf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965999AbXCPWf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:35:29 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52945 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965995AbXCPWf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:35:29 -0400
Date: Fri, 16 Mar 2007 23:36:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cleanpatch: a script to clean up stealth whitespace added by a patch
Message-ID: <20070316223608.GA23123@uranus.ravnborg.org>
References: <200703162146.l2GLkV26012863@tazenda.hos.anvin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703162146.l2GLkV26012863@tazenda.hos.anvin.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 02:45:06PM -0700, H. Peter Anvin wrote:
> This script is a companion to the "cleanfile" script.  This cleans
> up a patch in unified diff format *before* it is applied.  Note that
> the empty lines at the end of file detection *requires* that the diff was
> taken with at least one line of context around each hunk, or bad things
> will happen.
> 
> This script cleans up various classes of stealth whitespace.  In
> particular, it cleans up:
> 
> - Whitespace (spaces or tabs)before newline;
> - DOS line endings (CR before LF);
> - Space before tab (spaces are deleted or converted to tabs);
> - Empty lines at end of file.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

This and the companion "cleanfile" has been applied to kbuild.git.

	Sam
