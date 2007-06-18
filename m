Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbXFRKx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbXFRKx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760201AbXFRKxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:53:50 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49816 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbXFRKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:53:49 -0400
Date: Mon, 18 Jun 2007 12:54:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: More __meminit annotations.
Message-ID: <20070618105452.GA22386@uranus.ravnborg.org>
References: <20070618045229.GA31635@linux-sh.org> <20070618143943.B108.Y-GOTO@jp.fujitsu.com> <20070618074529.GA21222@uranus.ravnborg.org> <a781481a0706180329i688ece9fm4607c273ed3961bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706180329i688ece9fm4607c273ed3961bc@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> But then what
> might happen is that everybody would think his particular use of inline
> is correct and beneficial and all users of inline in kernel would end up
> as __always_inline anyway.

You miss that there is a big difference between "beneficial" and "needs".
The latter is used when some assembly code has a specific knowlegde of
how parameters are passed or that the function signature for other good
reasons must not change.
It has nothing to do with "beneficial".
Any use of __always_inline outside arch/* is highly question able.
And most use of *inline* in drivers/* today is due to bad behaving gcc in the past.

	Sam
