Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYHLW4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYHLW4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYHLW4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:56:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:47064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYHLW4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:56:03 -0400
Date: Tue, 12 Aug 2008 15:53:19 -0700
From: Greg KH <greg@kroah.com>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Pavel Machek <pavel@suse.cz>, "Deguara, Joachim" <joachim.deguara@amd.com>,
       gregkh@ucw.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 1] x86: L3 cache index disable for 2.6.26
Message-ID: <20080812225319.GA12373@kroah.com>
References: <200807181603.52332.mark.langsdorf@amd.com> <20080808220011.GA12156@ucw.cz> <200808121104.09288.mark.langsdorf@amd.com> <20080812215659.GA12911@elf.ucw.cz> <6453C3CB8E2B3646B0D020C112613273C5AC68@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC68@sausexmb4.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 05:01:46PM -0500, Langsdorf, Mark wrote:
> > > +        for (i = 0; i < 2; i++) {
> > > +                unsigned int reg = 0;
> > > +
> > > +                pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
> > > +
> > > +                ret += sprintf(buf, "%s %x\t", buf, reg);
> > > +        }
> > > +	ret += sprintf(buf,"%s\n", buf);
> > 
> > So you print "buf" few times? Why? And you use both \t and \n 
> > as deliminer...
> 
> I'm printing the values of the two config registers into
> the string buffer, separated by tabs, and terminated by
> an EOL.  Is there a prefered way to do that instead of
> what I have?

Yes, two different files, one for each config register.

thanks,

greg k-h
