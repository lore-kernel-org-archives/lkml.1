Return-Path: <linux-kernel-owner+w=401wt.eu-S1763324AbZALWyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763324AbZALWyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbZALWqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:46:54 -0500
Received: from ams-iport-1.cisco.com ([144.254.224.140]:43020 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762281AbZALWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:46:52 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 17:46:51 EST
X-IronPort-AV: E=Sophos;i="4.37,255,1231113600"; 
   d="scan'208";a="30678712"
Date: Mon, 12 Jan 2009 22:36:21 +0000
From: Derek Fawcus <dfawcus@cisco.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org
Subject: Re: Re (hello?): [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090112223621.GA21489@cisco.com>
References: <20090107005813.GA4987@const.famille.thibault.fr> <20090109212358.GG5073@const.famille.thibault.fr> <20090109213555.7f9275c9@lxorguk.ukuu.org.uk> <20090109214357.GH5073@const.famille.thibault.fr> <20090109220144.6b99ed72@lxorguk.ukuu.org.uk> <20090109222341.GI5073@const.famille.thibault.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090109222341.GI5073@const.famille.thibault.fr>
User-Agent: Mutt/1.4.2.3i
Organization: Cisco Systems Limited (Company Number: 02558939), is registered in England and Wales with its registered office at 1 Callaghan Square, Cardiff, South Glamorgan CF10 5BT
Authentication-Results: ams-dkim-1; header.From=dfawcus@cisco.com; dkim=pass (
	sig from cisco.com/amsdkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 11:23:41PM +0100, Samuel Thibault wrote:
> Alan Cox, le Fri 09 Jan 2009 22:01:44 +0000, a écrit :
> > > > Surely that is just a new keymap ?
> > > 
> > > No. That would mean a lot of keymapSSS. Doing it the keymap way
> > 
> > Why - its an  algorithmic question about how to edit them - remember you
> > can edit keymaps in programs at runtime and live.
> 
> Right. I'm still afraid by that: we'd need to know how to remap the
> various keycodes (amiga, atari, i386, mc, sun).

Err - just use EVIOCSKEYCODE to swap the keycodes around,  this works
in terms of the evdev keycodes.  I use it in a small program to swap
around a bunch of keys.

A bit more of a challange would be listening to evdev,  and when
detecting the 'swap' keycode,  doing the reload with the actual swaps.

I'm not sure w/o reading the code if the kernel will allow this to be
shared between the tty and evdev on the same vt,  but then one could
run a controller program talking through a pty and direct to the keyboard.

DF
