Return-Path: <linux-kernel-owner+w=401wt.eu-S1765557AbXLTOjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765557AbXLTOjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965179AbXLTOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:30:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2242 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965161AbXLTOaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:30:01 -0500
Date: Wed, 5 Dec 2007 20:31:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       akpm@linux-foundation.org, cbou@mail.ru
Subject: Re: [PATCH 1/2] power: remove POWER_SUPPLY_PROP_CAPACITY_LEVEL
Message-ID: <20071205203109.GA3889@ucw.cz>
References: <20071212141256.6c290271@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212141256.6c290271@ephemeral>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-12-12 14:12:56, Andres Salomon wrote:
> 
> The CAPACITY_LEVEL stuff defines various levels of charge; however, what
> is the difference between them?  What differentiates between HIGH and NORMAL,
> LOW and CRITICAL, etc?

On embedded hw, it is quite common that you can sense only 4-or-so
levels of battery charge, very non-linear. I suspect that's what capacity_level comes
from.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
