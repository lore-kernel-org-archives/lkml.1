Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZKMH2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZKMH2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZKMH2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:28:30 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43588 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbZKMH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:28:29 -0500
X-Sasl-enc: /Xrar6/5SUAIKaBABvgf91mk9KljdicwT8A54a49XfGU 1258097314
Message-ID: <4AFD0AA2.7070205@ladisch.de>
Date: Fri, 13 Nov 2009 08:28:34 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Daniel Mack <daniel@caiaq.de>
CC: Pavel Machek <pavel@ucw.cz>, David Newall <davidn@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
References: <4AF7D439.4030305@ladisch.de>	<20091109091044.GX29442@buzzloop.caiaq.de>	<4AF7DDC1.4090006@ladisch.de>	<20091109095316.6283fbd6@lxorguk.ukuu.org.uk>	<4AF7FC64.6030904@ladisch.de>	<20091109114600.4d91b90e@lxorguk.ukuu.org.uk>	<20091109145056.GB14091@buzzloop.caiaq.de>	<4AF8582B.2000403@davidnewall.com>	<20091109220944.GH14091@buzzloop.caiaq.de>	<20091110210940.GA1590@ucw.cz>	<20091110152605.fc8e760e.akpm@linux-foundation.org>	<4AFA603B.6000102@ladisch.de> <20091112140546.303e7dd6.akpm@linux-foundation.org>
In-Reply-To: <20091112140546.303e7dd6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Clemens Ladisch <clemens@ladisch.de> wrote:
> > [PATCH] vt: make the default cursor shape configurable
> > 
> > Make the default console cursor type configurable rather than
> > hard-coding it.
> 
> The changelog omitted the most important piece of information: the
> reason why we're making this change to the kernel.

[PATCH] vt: make the default cursor shape configurable

For embedded systems, the blinking cursor at startup time can be
annoying and unintended. Add a new kernel parameter to change the
default cursor shape.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
Daniel, could you ack this?
