Return-Path: <linux-kernel-owner+w=401wt.eu-S1765895AbYBZVuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765895AbYBZVuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762963AbYBZVu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:50:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:26358 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762750AbYBZVuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qa/2MGVRtnK+rAAyJeqI+YxcjwMjbtbFaujf+4EN+jmLZ3SDwSL2v2IjeyYQpCppw4jOhC4mA2nKzb/Ze57KyasS3Y9hULOuC6icedRYFO1O+5N/h37CfudtgphUe+1R6rSo2rqU+JK6k25t2wcCefbiW9CIDvwH0bQlR/95sSs=
Subject: Re: [Linux-fbdev-devel] [PATCH] fbcon: replace mono_col macro with
	static inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0802262235150.22486@anakin>
References: <1203963237.5582.4.camel@brick>
	 <Pine.LNX.4.64.0802260917410.5158@anakin> <1204059074.5582.35.camel@brick>
	 <Pine.LNX.4.64.0802262235150.22486@anakin>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 13:50:02 -0800
Message-Id: <1204062602.5582.38.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 22:36 +0100, Geert Uytterhoeven wrote:
> On Tue, 26 Feb 2008, Harvey Harrison wrote:
> > On Tue, 2008-02-26 at 09:18 +0100, Geert Uytterhoeven wrote:
> > > On Mon, 25 Feb 2008, Harvey Harrison wrote:
> > > > +static inline int mono_col(struct fb_info *info)
> > >                               ^^^^^^^^^^^^^^^^^^^^
> > > const struct fb_info *info?
> > 
> > I suppose, but seeing as it's an inline, does it really matter?
> 
> Sure, if one day a new routine calls mono_col() passing a const struct fb_info
> pointer, it won't compile.

Fair enough, want an updated patch, or will Andrew just make the small
addition?

Harvey

