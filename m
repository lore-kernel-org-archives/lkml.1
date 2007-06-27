Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbXF0Qxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbXF0Qxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXF0Qxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:53:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51116 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbXF0Qxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:53:40 -0400
Subject: Re: scheduling while atomic and DEBUG_SPINLOCK_SLEEP
From: Arjan van de Ven <arjan@infradead.org>
To: Jon Ringle <jon@ringle.org>
Cc: Jon Ringle <JRingle@vertical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46820316.7070406@ringle.org>
References: <4DD3AF7ECBBC43409BA36508938D01851B0E7E@CVAEX1.VERTICAL.COM>
	 <1182919609.3201.2.camel@laptopd505.fenrus.org>
	 <46820316.7070406@ringle.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 27 Jun 2007 06:28:40 -0700
Message-Id: <1182950920.3201.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 02:26 -0400, Jon Ringle wrote:
> Arjan van de Ven wrote:
> > On Tue, 2007-06-26 at 22:55 -0400, Jon Ringle wrote:
> >   
> >> Hello,
> >> Out of these two, the first one that is showing "in_atomic():1" seems
> >> more likely to me to be a potential cause of the "scheduling while
> >> atomic" dump.
> >>
> >> Does this logic seem reasonable? Are there other debugging techniques I
> >> can use to narrow down the cause for the "scheduling while atomic"?
> >>     
> >
> >
> > you could start by giving us pointers to the sources of the two
> > drivers... without that... how can we look and help?
> >
> >   
> You can get Intel's source from here:
> GPL_ixp400LinuxEthernetDriverPatch-1_5.zip:
> http://downloadcenter.intel.com/detail_desc.aspx?agr=N&ProductID=2100&DwnldID=9519
> 
> BSD_ixp400AccessLibrary-2_1.zip:
> http://downloadfinder.intel.com/scripts-df/detail_desc.asp?agr=Y&ProductID=2100&DwnldID=10146


ok that intel driver is quite buggy; I'll try to find the right folks at
work. You forgot to put the URL for your driver in though; based on the
backtrace it's also buggy, but without the code.... 

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

