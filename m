Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbYBOHdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbYBOHdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 02:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761529AbYBOHdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 02:33:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51312 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765018AbYBOHdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 02:33:15 -0500
Date: Fri, 15 Feb 2008 08:33:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let DEBUG_SECTION_MISMATCH depend on BROKEN
Message-ID: <20080215073306.GA28588@uranus.ravnborg.org>
References: <20080215005648.GK23227@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215005648.GK23227@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 02:56:48AM +0200, Adrian Bunk wrote:
> The pattern for making a config option on purpose not available is a 
> dependency on BROKEN.
BROKEN says that what is selected by the cofig option
is broken.
This is not the case for DEBUG_SECTION_MISMATCH which is
why it was made dependent on something else.

	Sam
