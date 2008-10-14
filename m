Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYJNTl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYJNTl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYJNTlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:41:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbYJNTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:41:50 -0400
Date: Tue, 14 Oct 2008 12:41:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [GIT] HID patches for 2.6.28
In-Reply-To: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz>
Message-ID: <alpine.LFD.2.00.0810141236590.3288@nehalem.linux-foundation.org>
References: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Oct 2008, Jiri Kosina wrote:
> 
> could you please pull from 'for-linus' branch of
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> 
> to receive 2.6.28 patches for the HID (the HIDeously slow devices, you 
> know) code.

This is really HIDeous. Disgusting.

The new Kconfig options are almost uselessly described, and very annoying 
and this adds several new warnings of the type:

	drivers/hid/hid-lg.c:342: warning: ¡hid_compat_logitech¢ defined but not used

which is just unacceptable.

I have an entirely warningless build. I'm not going to break that over 
something like this. Not pulled. Please fix.

As to the Kconfig options - do they really add so much space that you need 
to ask for the quirks? You didn't use to. Can you make the questions 
depend on EMBEDDED, or at least on the HID_COMPAT thing or whatever?

		Linus
