Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbZAPTgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbZAPTgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZAPTgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:36:09 -0500
Received: from solo.fdn.fr ([80.67.169.19]:52045 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZAPTgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:36:07 -0500
Date: Fri, 16 Jan 2009 20:36:03 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org
Subject: Re: Re (hello?): [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090116193603.GA5401@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
References: <20090107005813.GA4987@const.famille.thibault.fr> <20090109212358.GG5073@const.famille.thibault.fr> <20090109213555.7f9275c9@lxorguk.ukuu.org.uk> <20090109214357.GH5073@const.famille.thibault.fr> <20090115074044.GA1599@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090115074044.GA1599@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Thu 15 Jan 2009 08:40:44 +0100, a écrit :
> On Fri 2009-01-09 22:43:57, Samuel Thibault wrote:
> > Alan Cox, le Fri 09 Jan 2009 21:35:55 +0000, a écrit :
> > > Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > > > Came somebody have a look at this?  The need is real, the only question
> > > > that comes to my mind is whether notifiers are allowed to modify the
> > > > param they are given.  Since they are not marked const, I'd guess it'd
> > > > be ok?
> > > 
> > > The notifier code doesn't care.
> > 
> > I know, but I'm asking about current practice.
> > 
> > > > Make kbd_keycode() read param.value after calling the keyboard notification
> > > > chain, to let the callee change the translation on the fly. This for instance
> > > > permits to remap the physical positions of the keys independently of the
> > > > configured keymap, for e.g. single-handed people.
> > > 
> > > Surely that is just a new keymap ?
> > 
> > No. That would mean a lot of keymapSSS. Doing it the keymap way
> > would require to have us, us-revert-left, us-revert-right, en-uk,
> > uk-revert-left, uk-revert-right, etc. I really don't like that approach,
> > thus the "independently of the configured keymap".
> 
> ...and that is ok if you autogenerate those keymaps, right?
> 									Pavel

I have already answered that, see

http://marc.info/?l=linux-kernel&m=123153985127010&w=2

Samuel
