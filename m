Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbYBOO6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbYBOO6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760799AbYBOO6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:58:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57448 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118AbYBOO6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:58:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] move wakeup code to .c
Date: Fri, 15 Feb 2008 15:56:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, hpa@zytor.com,
       sam@ravnborg.org
References: <20080210222723.GA1865@elf.ucw.cz> <200802150135.07127.lenb@kernel.org> <20080215095544.GA4667@ucw.cz>
In-Reply-To: <20080215095544.GA4667@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802151556.05521.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 15 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > scripts/checkpatch.pl
> > ERROR: do not initialise externals to 0 or NULL
> > #113: FILE: arch/x86/boot/video-mode.c:29:
> > +int do_restore = 0;    /* Screen contents changed during mode flip */
> 
> We were doing file move with minimal changes.
> 
> > ERROR: need a space before the open parenthesis '('
> > #710: FILE: arch/x86/kernel/acpi/realmode/wakemain.c:70:
> > +               while(1);
> 
> Bogus warning.
> 
> I'll fix al but this one, but could we do it as a followup patch? I'm
> currently at holidays, moving .S code into .c is rather
> good/important, and it should get testing ASAP.

I'll move the definitions into a header file.

Thanks,
Rafael
