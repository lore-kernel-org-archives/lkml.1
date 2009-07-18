Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZGRQTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZGRQTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZGRQTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:19:30 -0400
Received: from solo.fdn.fr ([80.67.169.19]:46389 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZGRQT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:19:29 -0400
Date: Sat, 18 Jul 2009 18:19:26 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       stable@const.famille.thibault.fr
Subject: Re: vc: create vcs(a) devices for consoles
Message-ID: <20090718161926.GN28509@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>, stable
References: <1247931257.29760.1.camel@yio.site> <20090718160101.GA13346@kroah.com> <ac3eb2510907180912u7b30d8actcfab15776fe2d99d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510907180912u7b30d8actcfab15776fe2d99d@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers, le Sat 18 Jul 2009 18:12:20 +0200, a écrit :
> On Sat, Jul 18, 2009 at 18:01, Greg KH<greg@kroah.com> wrote:
> > On Sat, Jul 18, 2009 at 05:34:17PM +0200, Kay Sievers wrote:
> >> From: Kay Sievers <kay.sievers@vrfy.org>
> >> Subject: vc: create vcs(a) devices for consoles
> >>
> >> The buffer for the consoles are unconditionally allocated at
> >> con_init() time, which miss the creation of the vcs(a) devices.
> >>
> >> Since 2.6.30, these devices are no longer created at open()
> >> and removed on close(), but controlled by the lifetime of the
> >> buffers.
> >
> > Is this a bug in .31-rc right now?  Should this make it into the final
> > .31 release?
> 
> Yes, and in .30.

Please also push it to stable@kernel.org The bug makes the console
unusable e.g. for blind users using braille devices.

Samuel
