Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXDKNAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXDKNAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXDKNAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:00:51 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:37681 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXDKNAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:00:50 -0400
Date: Wed, 11 Apr 2007 14:58:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Egmont Koblinger <egmont@uhulinux.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070410185158.GA32259@uhulinux.hu>
Message-ID: <Pine.LNX.4.61.0704111454480.32056@yvahk01.tjqt.qr>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com>
 <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
 <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com>
 <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com>
 <20070410171924.GA18314@uhulinux.hu> <461BC99F.7020604@zytor.com>
 <20070410185158.GA32259@uhulinux.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 20:51, Egmont Koblinger wrote:
>On Tue, Apr 10, 2007 at 10:30:07AM -0700, H. Peter Anvin wrote:
>
>> Really?  Why is CJK so much more fundamental than, say, Arabic?
>
>Not more fundamental at all. It's just perhaps easier to "support" (I mean
>keep track of the cursor, not to really support them of course).
>
>I can't see any reason why these two scripts should be handled identically:
>either support both or none. If it's technically easier to support one and
>harder to support the other, why not implement the first now? Maybe someone
>will implement the other one later.
>
>Oh! Wait a moment! I haven't yet looked at bidi in Unicode, but taking the
>first glimpse it seems to me that U+200E and U+200F control the writing
>direction. Currently the kernel already skips 200E and 200F, doesn't print
>anything, not even a replacement character (see char/consolemap.c). This
>means that RTL is already "supported" at this level: eventually (when RTL
>mode is turned off) the cursor stands where it is expected to stand. In
>between, you either see the right number of replacement symbols, or (if your
>font supports Arabic) you may see the symbols in reverse order. So, after
>all, it's not worse at all than what I want to reach with CJK.

RTL is not supported, and perhaps we should not try. xterm does not do it
either AFAICT.

http://ttyrpld.svn.sourceforge.net/viewvc/ttyrpld/trunk/locale/fa_IR/LC_MESSAGES/ttyrpld.po?revision=15&view=markup
for simple sample data.


Jan
-- 
