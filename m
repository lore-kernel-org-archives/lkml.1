Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbXEXH2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbXEXH2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXEXH2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:28:41 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36491 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbXEXH2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:28:40 -0400
Date: Thu, 24 May 2007 09:28:17 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Zan Lynx <zlynx@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <200705232328.42657.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0705240926490.27422@twin.jikos.cz>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <1179962229.8575.4.camel@localhost> <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
 <200705232328.42657.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Dmitry Torokhov wrote:

> It looks like you are now in the same position I was some time ago WRT 
> to debug information for i8042 - constantly asking people to enable 
> debug, recompile and send the results. May I recommend changing 
> CONFIG_HID_DEBUG to "default y if !EMBEDDED" and controlling debug 
> output via a module parameter? -ENOPATCH though...

Hi Dmitry,

this is exactly what I have been thinking a couple of days ago, I am 
currently in the process of creating a patch, it's quite annoying to ask 
people to recompile kernel every time.

Thanks,

-- 
Jiri Kosina
