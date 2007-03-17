Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXCQIcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXCQIcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXCQIcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:32:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50651 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXCQIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:32:22 -0400
Date: Sat, 17 Mar 2007 09:33:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Distinguish between errors and warnings in modpost
Message-ID: <20070317083302.GD27451@uranus.ravnborg.org>
References: <11602209321133-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11602209321133-git-send-email-matthew@wil.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 07, 2006 at 05:35:32AM -0600, Matthew Wilcox wrote:
> Some of modpost's warnings are fatal, and some are not.  Adopt the
> compiler distinction between errors and warnings by calling error()
> for fatal diagnostics and warn() for non-fatal ones.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Applied - but I named it merror to avoid clash with glibc and
declared it in modpost.h too.

	Sam
