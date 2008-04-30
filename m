Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbYD3LXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbYD3LXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbYD3LXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:23:44 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:62781 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbYD3LXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:23:44 -0400
Message-ID: <481856AD.3020004@aknet.ru>
Date: Wed, 30 Apr 2008 15:23:25 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-tiny <Linux-tiny@selenic.com>
Subject: Re: [patch] pcspkr: fix dependancies
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv> <481626B6.5040207@aknet.ru> <20080428155811.ZZRA012@mailhub.coreip.homeip.net> <20080428201225.GB18135@uranus.ravnborg.org> <48177D70.5010803@aknet.ru> <4818205B.7050202@free-electrons.com>
In-Reply-To: <4818205B.7050202@free-electrons.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michael Opdenacker wrote:
> I agree with you... on a regular system, all the platform devices should
> be enumerated, even if we don't use their drivers. It's only for use in
> embedded devices (CONFIG_EMBEDDED) that we could omit this enumeration
> to reduce kernel size.
> Would you post a patch doing this?
Certainly, this was done.
http://uwsg.ucs.indiana.edu/hypermail/linux/kernel/0804.3/1189.html
Does this help?
