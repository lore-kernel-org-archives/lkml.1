Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbXJCWPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbXJCWPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXJCWPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:15:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:47273 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754745AbXJCWPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:15:03 -0400
Date: Wed, 3 Oct 2007 23:55:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tomoya Adachi <adachi@il.is.s.u-tokyo.ac.jp>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbhid: report descriptor fix for MacBook JIS keyboard
In-Reply-To: <41620071003212350adachi@il.is.s.u-tokyo.ac.jp>
Message-ID: <Pine.LNX.4.64.0710032352350.20620@jikos.suse.cz>
References: <41620071003212350adachi@il.is.s.u-tokyo.ac.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Tomoya Adachi wrote:

> This patch fixes the problem, that Japanese MacBook doesn't recognize 
> some keys like '\'(yen, or backslash), '|'(pipe), and '_'(underscore). 
> It is due to that MacBook JIS keyboard (jp106) sends wrong report 
> descriptor. It saids "logical maximum = 0x65", so Keyboard.0089 is 
> mapped to Key.Unknown, while it should be accepted as Key.Yen.

Hi Tomoya,

thanks a lot for debugging and fixing this. I have applied your patch to 
my tree.

-- 
Jiri Kosina
SUSE Labs
