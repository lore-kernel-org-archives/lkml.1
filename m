Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYJZA3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYJZA3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYJZA27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:28:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59801 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYJZA26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:28:58 -0400
Date: Sun, 26 Oct 2008 02:28:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
In-Reply-To: <200810242046.02743.dmitry.torokhov@gmail.com>
Message-ID: <Pine.LNX.4.64.0810260226080.22126@twin.jikos.cz>
References: <1224879959.3248.32.camel@calx> <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz>
 <1224890002.3248.71.camel@calx> <200810242046.02743.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008, Dmitry Torokhov wrote:

> I would like to get rid of .ident strings in cases when drivers don't
> use them for anything, this should free some more memory.

Yes, that could be nice thing to do indeed. They are usually used only to 
store a human-readable description of the device anyway, which is then not 
printed anywhere, and therefore a plain C comment should be sufficient 
instead.

It will require fixing dmi_check_system() though, as it's one of those 
rare functions actually using ->ident field for detecting end of the list.

-- 
Jiri Kosina
SUSE Labs

