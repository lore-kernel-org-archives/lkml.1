Return-Path: <linux-kernel-owner+w=401wt.eu-S965202AbXBVBuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202AbXBVBuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965211AbXBVBug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:50:36 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:46437 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965202AbXBVBuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Owf+ukXXCZImppWp2sIQhdhLrMYlcvZAhrLA2WY7dEKqZkJpTwIwcdEyiWRcC9BOE6pYQRmOOvEo6ESXy7eL1wGP5b2iGFcneznHnlQ2ni+ObquNuh+qI61kZDbF4hw8m+Xg0FONzS1eecF9vgrX3MAG1WHr2hNTMWZrfzqXSSM=
Subject: Re: [Linux-fbdev-devel] [PATCH]
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702220119060.17121@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702212105280.20620@pentafluge.infradead.org>
	 <1172106234.4217.50.camel@daplas>
	 <Pine.LNX.4.64.0702220119060.17121@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:53:26 +0800
Message-Id: <1172109206.4217.61.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 01:35 +0000, James Simmons wrote:
> > On Wed, 2007-02-21 at 21:23 +0000, James Simmons wrote:

> > If this is an attempt to consolidate, I don't see the 'brightness'
> > hook of backlight and lcd.
> > 
> > If this is not a consolidation, why don't we just extend the lcd class?
> 
> Its is a replacement for lcd. Is brightness universal for all display 
> types?

Well, if you're adding a universal interface, you need hooks for more
than that (brightness, contrast, hue, saturation, tint, etc).  Then we
just let the drivers cherry pick from the list on what it's going to
support.

Tony

