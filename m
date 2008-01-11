Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbYAKTkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbYAKTkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbYAKTk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:40:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47081 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbYAKTk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:40:26 -0500
Date: Fri, 11 Jan 2008 11:40:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080111114002.3e59d1ad@laptopd505.fenrus.org>
In-Reply-To: <20080111192820.GM18741@parisc-linux.org>
References: <20071225032605.29147200@laptopd505.fenrus.org>
	<20080111190229.GB10112@kroah.com>
	<20080111192820.GM18741@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 12:28:20 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Jan 11, 2008 at 11:02:29AM -0800, Greg KH wrote:
> > Can you send me a follow-on patch that documents this in
> > Documentation/ABI please.
> 
> Greg, if you integrate Ivan's patch, you don't need Arjan's patch.
> 

Personally I absolutely don't agree with that.
Ivan's patch is another attempt to make MMCONFIG work somewhat better,
but does not provide the explicit opt-in that I think is required at
this point; people have tried to get MMCONFIG stable for a really long time,
and failed still upto today. At least my patience is up and this needs
to be opt-in.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
