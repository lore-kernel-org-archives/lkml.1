Return-Path: <linux-kernel-owner+w=401wt.eu-S1762719AbYEEXy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719AbYEEXy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYEEXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:54:48 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:3765 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbYEEXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:54:47 -0400
Date: Tue, 6 May 2008 00:54:34 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: w@1wt.eu, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Fix VT canonical input in UTF-8 mode [Was: UTF-8 fixes in comments]
Message-ID: <20080505235434.GE4790@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>, w@1wt.eu,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu> <20080503235027.GO8032@implementation> <20080504085514.GA27263@1wt.eu> <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu> <20080503235027.GO8032@implementation> <20080504102554.GA4729@implementation> <20080505160044.dcc36a51.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080505160044.dcc36a51.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, le Mon 05 May 2008 16:00:44 -0700, a écrit :
> > Set IUTF8 as appropriate on VT tty open.
> > 
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> That changelog is pretty darn terse :( 

Erf, sorry.

> I'll often go through
> the email ladder and try to extract the missing information
> but this time I don't really see it there.
> 
> Things like: what is the kernel's current behaviour, why does
> it behave that way, how does the patch fix it?

Well, it's more an implementation than a fix. Let's try again:



For e.g. proper TTY canonical support, IUTF8 termios flag has to be set
as appropriate.  Linux used to not care about setting that flag for VT
TTYs.

This patch fixes that by activating it according to the current mode
of the VT, and sets the default value according to the vt.default_utf8
parameter.



Samuel
