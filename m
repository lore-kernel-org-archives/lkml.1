Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbXEXVwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbXEXVwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXEXVwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:52:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:2423 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXEXVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IehFrdvU0Pv5QtqINIggYGqPwZwFkhs4BYZx/kDLYZhJeoQnQwRzffjDRV8lP6m3Gocn+wGrOS7z3idadBm98AjsB58bbsn0y53nEW/d9kZZHWdUTw/KkZ1X9WsJ3c3y/+W9BkutQIsSsDlREWKFWBdz8tqZdRZg5iLfZhG/D+8=
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69]
	-stablereview)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070524211237.GC1372@uranus.ravnborg.org>
References: <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
	 <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
	 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
	 <1180037649.15241.6.camel@localhost>
	 <20070524140154.c8e93d69.akpm@linux-foundation.org>
	 <20070524211237.GC1372@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 24 May 2007 23:51:53 +0200
Message-Id: <1180043514.15241.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 23:12 +0200, Sam Ravnborg wrote:

> 
> I really cannot see why it makes a difference.
> If you use += (and :=) make will resolve EXTRA_CFLAGS when it see it.
> Whereas with = make will resolve it only when actually referenced.
> 
> But the way we use EXTRA_CFLAGS it should not matter.
> If the fix above really helps nfs I need to take a closer look tomorrow.
> 

No, you're right, it doesn't help. What could help is a form of saying
to make "add this EXTRA_CFLAGS  to whatever is specified in the command
line". No idea if it exists.

Romano


