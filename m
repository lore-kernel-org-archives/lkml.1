Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbXFUTm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbXFUTm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXFUTmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:42:37 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:37618 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbXFUTme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:42:34 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
References: <467994BD.6000403@zytor.com> <87abuu2q3w.fsf@hades.wkstn.nix>
	<E1I1KA8-0007Fu-00@dorka.pomaz.szeredi.hu>
From: Nix <nix@esperi.org.uk>
Emacs: it's all fun and games, until somebody tries to edit a file.
Date: Thu, 21 Jun 2007 20:42:27 +0100
In-Reply-To: <E1I1KA8-0007Fu-00@dorka.pomaz.szeredi.hu> (Miklos Szeredi's message of "Thu, 21 Jun 2007 12:45:16 +0200")
Message-ID: <87sl8l14d8.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Jun 2007, Miklos Szeredi said:
> I'm working on this actually.  See this (and related patches) in -mm:
>
>   http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/broken-out/unprivileged-mounts-add-user-mounts-to-the-kernel.patch
>
> This solves the "user=" thing, but is not a generic solution for other
> options.  And I'm wondering if there is really a need for that.

I'm not sure there is, actually...

> Which quota options are you thinking about?  Some quota options
> (e.g. for ext*) seem to be already present in /proc/mounts.

... last I checked, usrquota and grpquota weren't being propagated in,
but that's changed sometime in the last, um, wow, has it been two
years already? Perhaps I should have checked again before babbling
nonsense to an audience of thousands, sorry!

> Do you know any other options which are only in /etc/mtab, and need to
> be stored along with each mount?

None presently, but in general it seems strange to have to modify the
kernel in order to be able to reliably associate some new key/value pair
with a mount point, let alone to have to do it on a filesystem-by-
filesystem basis...

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
