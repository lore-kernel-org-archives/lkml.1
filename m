Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbXJYOLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbXJYOLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXJYOLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:11:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38170 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447AbXJYOLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:11:36 -0400
Date: Thu, 25 Oct 2007 16:13:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [IDE] Fix build bug
Message-ID: <20071025141305.GA11698@uranus.ravnborg.org>
References: <20071025135334.GA23272@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025135334.GA23272@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 02:53:34PM +0100, Ralf Baechle wrote:
>   CC      drivers/ide/pci/generic.o
> drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> +section type conflict
> 
> This sort of build error is becoming a regular issue.  Either all or non
> of the elements that go into a particular section of a compilation unit
> need to be const.  Or an error may result such as in this case if
> CONFIG_HOTPLUG is unset.
So we can avoid this if we invent a __constinitdata tag that uses
a new section?
I ask mainly to understand this error - not that I am that found
of the idea.

	Sam
