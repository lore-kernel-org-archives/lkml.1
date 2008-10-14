Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYJNUMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYJNUMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYJNUMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:12:14 -0400
Received: from styx.suse.cz ([82.119.242.94]:43991 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752244AbYJNUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:12:14 -0400
Date: Tue, 14 Oct 2008 22:12:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [GIT] HID patches for 2.6.28
In-Reply-To: <alpine.LFD.2.00.0810141236590.3288@nehalem.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0810142205170.26779@jikos.suse.cz>
References: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz> <alpine.LFD.2.00.0810141236590.3288@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Linus Torvalds wrote:

> The new Kconfig options are almost uselessly described, and very 
> annoying and this adds several new warnings of the type:
> 	drivers/hid/hid-lg.c:342: warning: ?hid_compat_logitech? defined but not used
> which is just unacceptable.

Hmm, this is because of Harvey Harrison's (CC added) patch that was used 
to silence sparse warning, but it is wrong as Jiri correctly pointed out 
on http://lkml.org/lkml/2008/9/4/495 but I somehow completely missed that 
mail.

Will fix that up.

> As to the Kconfig options - do they really add so much space that you 
> need to ask for the quirks? You didn't use to. Can you make the 
> questions depend on EMBEDDED, or at least on the HID_COMPAT thing or 
> whatever?

Probably makes sense, yes. I will send you a new pull request.

-- 
Jiri Kosina
