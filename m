Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbXJYONg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbXJYONg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXJYON1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:13:27 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:44267 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXJYON0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:13:26 -0400
Date: Thu, 25 Oct 2007 15:13:13 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [IDE] Fix build bug
Message-ID: <20071025141313.GA23536@linux-mips.org>
References: <20071025135334.GA23272@linux-mips.org> <20071025141305.GA11698@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025141305.GA11698@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:13:05PM +0200, Sam Ravnborg wrote:

> On Thu, Oct 25, 2007 at 02:53:34PM +0100, Ralf Baechle wrote:
> >   CC      drivers/ide/pci/generic.o
> > drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> > +section type conflict
> > 
> > This sort of build error is becoming a regular issue.  Either all or non
> > of the elements that go into a particular section of a compilation unit
> > need to be const.  Or an error may result such as in this case if
> > CONFIG_HOTPLUG is unset.
> So we can avoid this if we invent a __constinitdata tag that uses
> a new section?
> I ask mainly to understand this error - not that I am that found
> of the idea.

Yes.

  Ralf
