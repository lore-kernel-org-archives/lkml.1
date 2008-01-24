Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYAXVjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYAXVjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYAXVjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:39:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:26310 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYAXVjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:39:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JMP46Lw/qhsurgh1prrwrj3jWQPWIaOFbFaaZWDNq+Wq17qiW0z7f2QHJL0mfrC+JYoOOqqp/5H83RXUg1IUkdhJADy+xC3OOIT+t4/RPQdFvhAGONRlhcvosYBSUR735B+b38d/9y8pwOmX5BoGHikqWnEAMby3fMweFm7WRGU=
From: Marcin Gil <marcin.gil@gmail.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Date: Thu, 24 Jan 2008 22:39:02 +0100
User-Agent: KMail/1.9.7
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
References: <200801232323.36187.marcin.gil@gmail.com> <m3abmvtah1.fsf@maximus.localdomain> <20080124172226.GG16171@csclub.uwaterloo.ca>
In-Reply-To: <20080124172226.GG16171@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801242239.02196.marcin.gil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia czwartek 24 stycznia 2008, Lennart Sorensen napisał:
> On Thu, Jan 24, 2008 at 06:11:22PM +0100, Krzysztof Halasa wrote:
> > Marcin Gil <marcin.gil@gmail.com> writes:
> > > +-----+-----+
> > > mobo  hdd   dvd
> > >
> > > I think that cable select would take dvd as master and hdd as slave.
> > > This was not preferable when hdd was my primary drive. I can try
> > > cable-select now since I boot off new SATA drive.
> >
> > Is a master in the middle permitted by the specs at all?
>
> On 40 pin cable select it was in fact required.  On 80pin the end is the
> master and the middle the slave which I believe is supposed to give
> better signal quality when only one device is in use.

Ok. I've just configured drives to cable-select. Everything works fine.
Both DVD and IDE HDD are detected correctly. SATA drive (slot SATA0) is sda, 
IDE HDD is sdb and DVD is sr0.

Looks like my problem is now solved. What is just curious to me is that it 
worked fine with old ATA..

Thank you all for your patience and time.
-Marcin Gil
