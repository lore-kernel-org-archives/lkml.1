Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbXELLIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbXELLIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXELLIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:08:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62596 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbXELLIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=EH33707jY9PX5vkgyyp0cLV0S8z52oCPjupbfufx9QXNzrHE+z3gCoq2q+rAsKdfGzDzO9ocdPByCscfVetV4mlMoQ/d/GvL9tgcL46ONxXiWpl4BDcql+Hlnoo/Vm7i3fPfcQ543y492By7wduUo3ADCMwshVNqCFR++DffEoQ=
Date: Sat, 12 May 2007 13:08:23 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Matt Keenan <tank.en.mate@gmail.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bradley Chapman <kakadu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HIGHMEM4G and 1GB RAM
Message-ID: <20070512130823.66bbeead@localhost.localdomain>
In-Reply-To: <46366B34.3050003@gmail.com>
References: <e294b46e0704281326w60f9cecfuace3442791f147b3@mail.gmail.com>
	<20070430001755.e9f203c9.akpm@linux-foundation.org>
	<20070430074044.GB19966@holomorphy.com>
	<46366B34.3050003@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 30 Apr 2007 23:18:28 +0100
Matt Keenan <tank.en.mate@gmail.com> escribió:

> William Lee Irwin III wrote:

> > The CONFIG_VMSPLIT config options were merged for such cases.
> >
> > It should be able to split on any 4MB-aligned boundary in
> > CONFIG_HIGHMEM4G. CONFIG_VMSPLIT_3G_OPT appears to do something of
> > this sort to use an entire 1GB RAM with minimal user address space
> > reduction.
> >
> > This is an ELF ABI violation but the number of major applications
> > that break is apparently low.
> >
> >   
> wine and some java implementations being two of the big caveats.

I'm happily using java6-jre and wine (latest versions) on self compiled
vanilla kernels with CONFIG_VMSPLIT_3G_OPT=y

For the record i use wine for utorrrent and SwitcherCADIII/LTspice and
java for sancho (front end to mldonkey). Some may think it is not a
heavy use

> 
> Matt
> 
Alejandro
