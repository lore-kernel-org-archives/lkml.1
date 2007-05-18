Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbXERQGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbXERQGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbXERQGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:06:01 -0400
Received: from zakalwe.fi ([80.83.5.154]:34524 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbXERQGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:06:00 -0400
Date: Fri, 18 May 2007 19:05:07 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Richard Purdie <richard@openedhand.com>
Cc: akpm <akpm@linux-foundation.org>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nitin Gupta <nitingupta910@gmail.com>
Subject: Re: [PATCH -mm] LZO: Further cleanup of the kernel LZO library headers
Message-ID: <20070518160507.GI10873@zakalwe.fi>
References: <1179499886.5876.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1179499886.5876.30.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 03:51:26PM +0100, Richard Purdie wrote:
> A further cleanup of the kernel LZO library headers which untangles and
> removes ~400 lines of defines. This doesn't change the core minilzo code
> so diffability is maintained.

You should just throw away that. Guptas implementation is much cleaner, 
work with that. Putting a few bound checks into Guptas version will 
solve crashes and overruns by returning an error.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
