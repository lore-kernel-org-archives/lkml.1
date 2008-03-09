Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYCIWnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYCIWnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 18:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYCIWnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 18:43:10 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:52137 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYCIWnJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:43:09 -0400
X-Greylist: delayed 2540 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Mar 2008 18:43:09 EDT
X-Envelope-From: zajio1am@artax.karlin.mff.cuni.cz
Date: Sun, 9 Mar 2008 23:00:25 +0100
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/4] gxfb: Replace FBSIZE config option with a kernel argument
Message-ID: <20080309220025.GD9971@localhost.localdomain>
References: <20080223011045.48e6cb8e@ephemeral> <20080227163105.e1b96023.akpm@linux-foundation.org> <20080227195839.1e86074e@ephemeral> <20080308201950.28f6eae8@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308201950.28f6eae8@ephemeral>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 08:19:50PM -0500, Andres Salomon wrote:
> > assuming this is historical at this point, and manual options parsing can
> > be removed from all fb drivers at this point, or is there another reason
> > why manual parsing would be necessary?
> > 
> 
> Could I get an answer from the fbdevel folks about this?  It looks like
> the fb_get_options stuff is there for backwards compatibility.

I think so. I used fb_get_options() in arkfb and vt8623fb for mode option
only. Universal notation module.option=value is much nicer than manual
options parsing.  

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org, jabber: santiago@njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
