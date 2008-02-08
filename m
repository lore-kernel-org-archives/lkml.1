Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYBHV6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYBHV6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYBHV6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:58:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYBHV6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:58:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Fri, 8 Feb 2008 22:56:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20080208210004.GA12923@elf.ucw.cz> <47ACC942.1020308@zytor.com> <20080208213101.GE12923@elf.ucw.cz>
In-Reply-To: <20080208213101.GE12923@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802082256.09081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 8 of February 2008, Pavel Machek wrote:
> On Fri 2008-02-08 13:27:30, H. Peter Anvin wrote:
> > Pavel Machek wrote:
> >>
> >> See arch/x86/kernel/acpi/realmode/wakeup.S (the version that was sent
> >> to the list). No problem there, but table stored at nonzero
> >> offset. Short jump at the beggining of table would fix it (ugly).
> >>
> >
> > Ugly, but it's the standard way to deal.  We have it in the bzImage format, 
> > too.
> 
> I'd prefer to keep it as it is, there are no problems.
> 
> This way, we can put debugging instructions at the first byte of
> wakeup code, which is somehow important.
> 
> Plus, with right #defines, it should be clean enough.

Well, I don't know how to evaluate #defines in *.ld files ...

Rafael
