Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYKKXWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYKKXWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKKXWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:22:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:42997 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751709AbYKKXWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:22:34 -0500
Date: Wed, 12 Nov 2008 00:22:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Helge Deller <deller@gmx.de>, Jiri Slaby <jirislaby@gmail.com>,
       Jeroen Roovers <jer@gentoo.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
In-Reply-To: <200811022024.31528.vda.linux@googlemail.com>
Message-ID: <alpine.LNX.1.10.0811120021500.24889@jikos.suse.cz>
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <490D873D.9010005@gmail.com> <490DDA69.4000404@gmx.de> <200811022024.31528.vda.linux@googlemail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008, Denys Vlasenko wrote:

> > I fully bisected it, and the final "buggy" patch seems to have been 
> > Denys Vlasenko's patch: cb8f488c33539f096580e202f5438a809195008f (see 
> > http://github.com/jonsmirl/digispeaker/commit/cb8f488c33539f096580e202f5438a809195008f) 
> > Denys: Any reason you removed "!prev" in front of "expand_stack"?
> Looks like I erroneously thought it can't be NULL,
> or that expand_upwards() is ok with getting NULL vma parameter.
> I looked again and neither is true.
> Sorry, looks like I indeed broke this.

Hmm, so ... ? Seems like this didn't get fixed in Linus' tree yet?

-- 
Jiri Kosina
SUSE Labs
