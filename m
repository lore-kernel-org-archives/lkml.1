Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZG1VHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZG1VHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZG1VHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:07:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZG1VHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:07:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses new device node
Date: Tue, 28 Jul 2009 23:07:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Carlos R. Mafra" <crmafra2@gmail.com>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <20090727175525.20ac4869@lxorguk.ukuu.org.uk> <20090728003120.500c5cf0@lxorguk.ukuu.org.uk> <874osxj7jb.fsf@tac.ki.iif.hu>
In-Reply-To: <874osxj7jb.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282307.53927.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Ferenc Wagner wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > commit 3f40612e940971ecec29d5375cdcc9f9c9a9f46e
> > Author: Alan Cox <alan@linux.intel.com>
> > Date:   Tue Jul 28 00:23:39 2009 +0100
> >
> >     tty: USB lock/refcounting fixes
> >     
> >     This fixes
> >     - locking bug that was hidden by ecc2e05e739c30870c8e4f252b63a0c4041f2724
> >     - Regression #13821
> >     - Spurious warning when closing and blocking for data write out
> >     
> >     With these changes my PL2303 always ends up as ttyUSB0 when it should and
> >     the module refcounts stay correct.
> >     
> >     I'll do a more wholesale split & tidy of _open in the next release or two
> >     as we get a standard tty_port_open and port->ops->init port->ops->shutdown
> >     call backs.
> >     
> >     Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> I confirm that current git (containing the above patch) has regression
> #13821 fixed, as well as the open bug discovered by Alan Stern.

Thanks, closed.

Rafael
