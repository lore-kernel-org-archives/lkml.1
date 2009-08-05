Return-Path: <linux-kernel-owner+w=401wt.eu-S964811AbZHEQhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811AbZHEQhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934623AbZHEQhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:37:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49934 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934128AbZHEQhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:37:35 -0400
Date: Wed, 5 Aug 2009 17:38:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <teheo@suse.de>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805173809.19022f3b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805173346.130d80bb@lxorguk.ukuu.org.uk>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A7951B0.10208@suse.de>
	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>
	<4A796C94.5040301@suse.de>
	<20090805134823.4409e197@lxorguk.ukuu.org.uk>
	<4A799392.3000108@suse.de>
	<20090805152942.42e785f3@lxorguk.ukuu.org.uk>
	<4A79AD2A.4060308@suse.de>
	<20090805173346.130d80bb@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 17:33:46 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I don't see how I would be able to achieve the latter with one liner.
> > Can you please elaborate a little bit?
> 
> It depends how much of a hurry you are in, but for the mainstream we can
> do this


and a PS to this

If we have a clear plan on obsoleting sound_, a proper documented entry
for it going obsolete and a clear roadmap which ends up with soundcore
being recycled[1] then adding a temporary option to soundcore to make it
shut up is much less of a problem because the option also clearly goes
obsolete with soundcore so no mess is left when the process is over -
which would let you get your CUSE stuff up as a hack in the meantime.

Ala
[1] 0 bits in the green bag, 1 bits in the black bag please
