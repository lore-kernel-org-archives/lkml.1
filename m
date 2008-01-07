Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYAGUlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYAGUlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYAGUlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:41:32 -0500
Received: from ns2.suse.de ([195.135.220.15]:45858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYAGUlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:41:32 -0500
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sleep before boot panic
From: Andi Kleen <andi@firstfloor.org>
References: <200801061908.43010.bernd-schubert@gmx.de>
Date: Mon, 07 Jan 2008 21:41:31 +0100
In-Reply-To: <200801061908.43010.bernd-schubert@gmx.de> (Bernd Schubert's message of "Sun\, 6 Jan 2008 19\:08\:42 +0100")
Message-ID: <p731w8ts70k.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert <bernd-schubert@gmx.de> writes:

> Hi,
>
> I just switched to libata (pata) on my laptop and the immediate panic made it 
> impossible to figure out why my boot partition wasn't available.
> After applying this little patch I could check boot printk output and then saw 
> everything was properly recognized and only scsi-disk support was missing.

The correct fix would be to make scroll back (and sysrq) still work
after panic.  It's a little more complicated, but possible (essentially
it needs a polled keyboard handler)

-Andi
