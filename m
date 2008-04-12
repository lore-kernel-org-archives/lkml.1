Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYDMJop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYDMJop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbYDMJoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:44:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3151 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754380AbYDMJoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:44:37 -0400
Date: Sat, 12 Apr 2008 21:57:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 7/8] rfkill: add an "any radio" switch type and functionality
Message-ID: <20080412195716.GA4639@ucw.cz>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-8-git-send-email-hmh@hmh.eng.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207946244-14525-8-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-04-11 17:37:23, Henrique de Moraes Holschuh wrote:
> Add a RFKILL_TYPE_ANY switch.  This switch can control more than one type
> of radio, and it is always subject to toggling by any type of rfkill-input
> event.  It is suitable to implement kill-all-radios functionality when
> coupled with input event EV_SW SW_RADIO.

Hmm, how does that work with pcmcia ethernet card plugged in?

How does userspace know which radios this controls?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
