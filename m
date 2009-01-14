Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbZANPYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbZANPYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZANPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:24:28 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:25198 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706AbZANPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:24:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAOSSbUnCTtAn/2dsb2JhbACBbMw0hW8
Date: Wed, 14 Jan 2009 16:24:23 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Rogan Dawes <lists@dawes.za.net>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
Message-ID: <20090114152423.GA24562@frolo.macqel>
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <1231926744.11907.12.camel@skunk> <20090114101828.GA15141@frolo.macqel> <496DF66B.3050609@dawes.za.net> <20090114145239.GB21043@frolo.macqel> <496DFD45.5030408@dawes.za.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496DFD45.5030408@dawes.za.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:57:09PM +0200, Rogan Dawes wrote:
> Philippe De Muyter wrote:
> > On Wed, Jan 14, 2009 at 04:27:55PM +0200, Rogan Dawes wrote:
> >> Philippe De Muyter wrote:
> >>
> >>> Keeping thinking about it, I now think that my 'application program'
> >>> (basically a serial-to-ethernet converter) should be a kernel thread,
> >>> because of the small memory constraints.
> >>>
> >>> The question is thus how to access the serial lines from a kernel thread.
> >>>
> >>> Philippe
> >> If your constraints are that severe, perhaps you should be investigating
> >> other solutions. e.g. eCos?
> > 
> > I like to reuse (and contribute to) the linux drivers and kernel.
> > 
> >> Linux doesn't ALWAYS have to be the answer :-)
> > 
> > No ? :)
> > 
> > Philippe
> > 
> 
> Ok, in that case, perhaps you should explain exactly what your
> constraints are (target board, max memory/flash, etc), and maybe folks
> will be able to provide more sensible answers.

if possible, mcf52236 (256k flash 32k sram in chip) :)

kernel+uapplication XIP in flash

they seems to push something called utasker

Philippe
