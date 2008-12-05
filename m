Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYLET3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYLET3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYLET3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:29:37 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49783 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbYLET3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:29:36 -0500
X-Sasl-enc: jkVmbwKwudoYQe82BkZVXD0OjZq1Play5cFwcPLDcp5p 1228505375
Date: Fri, 5 Dec 2008 17:29:32 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 011/104] fbdev: clean the penguins dirty feet
Message-ID: <20081205192932.GC27318@khazad-dum.debian.net>
References: <20081203193901.715896543@mini.kroah.org> <20081203194838.GL8950@kroah.com> <20081205125855.GA1750@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205125855.GA1750@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc: trimmed)

On Fri, 05 Dec 2008, Pavel Machek wrote:
> > commit cf7ee554f3a324e98181b0ea249d9d5be3a0acb8 upstream.
> > 
> > When booting in a direct color mode, the penguin has dirty feet, i.e.,
> > some pixels have the wrong color.  This is caused by
> > fb_set_logo_directpalette() which does not initialize the last 32 palette
> > entries.
> 
> Heh, funny, but... is this really bad enough bug to go to stable?

Well, it is a public health problem, since dirty feet in Penguins can spread
numerous diseases.

Imagine the *horror* if your box got the dreaded dancing-penguin disease
from those nasty dirty feet, and started trying to sing and dance... while
still booting!  It would be quite out of wack, and be horribly off-tune!
And if it happens on a PeeCee, it would be trying to sing its lungs off
through the DREADED PeeCee Squeaker...

That just Cannot Be Allowed To Happen(TM).

> > -	for (i = 32; i < logo->clutsize; i++)
> > +	for (i = 32; i < 32 + logo->clutsize; i++)

It is an one line change that can save us from untold horrors!  I call that
a patch well deserving of being in a stable release ;-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
