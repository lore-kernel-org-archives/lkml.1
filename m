Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbZGSXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbZGSXCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZGSXCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 19:02:16 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51849 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751724AbZGSXCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 19:02:16 -0400
Date: Sun, 19 Jul 2009 18:02:12 -0500
From: Robin Holt <holt@sgi.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: Commit 9b57896e removed my Vaio S1 S2 keys for brightness +/-.
Message-ID: <20090719230212.GD7426@sgi.com>
References: <20090719222236.GJ6876@sgi.com> <20090719222605.GA14554@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090719222605.GA14554@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 11:26:05PM +0100, Matthew Garrett wrote:
> On Sun, Jul 19, 2009 at 05:22:36PM -0500, Robin Holt wrote:
> > Matthew,
> > 
> > I am not sure whether this is a bug or just something not configured
> > correctly.  I am running Ubuntu 9.04 and finally decided to find out why
> > the S1 and S2 buttons no longer brighten or dim the display.  Prior to
> > commit 9b57896e, they behaved equivalent to the Fn-F5 and Fn-F6 keys
> > for brightness up/down.
> 
> I suspect that they're now working correctly, whereas previously they 
> weren't. Do they generate input events when you press them? You can 
> probably map them back to KEY_BRIGHTNESSUP and KEY_BRIGHTNESSODNW.

You are correct.  They now seem to generate XF86Launch1 and XF86Launch2.

Thanks,
Robin
