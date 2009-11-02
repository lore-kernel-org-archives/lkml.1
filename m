Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZKBJOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZKBJOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZKBJOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:14:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48225 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751008AbZKBJOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:14:50 -0500
Date: Mon, 2 Nov 2009 09:16:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: =?ISO-8859-14?B?TeVucyBSdWxsZ+VyZA==?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091102091611.60dfeea1@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.OSX.1.10.0911012023020.55434@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley>
	<yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm certain if we made a Venn diagram, there would be an overlap. But 
> FatELF solves different problems than package managers, and in the case of 
> ia32 compatibility packages, it helps the package manager solve its 
> problems better.

Not really - as I said it drives disk usage up, it drives network
bandwidth up (which is a big issue for a distro vendor) and the package
manager and file system exist to avoid this kind of mess being needed.

You can ask the same question as FatELF the other way around and it
becomes even more obvious that it's a bad idea.

Imagine you did it by name not by architecture. So you had a single
"FatDirectory" file for /bin, /sbin and /usr/bin. It means you don't have
to worry about people having different sets of binaries, it means they
are always compatible. And like FatELF it's not a very good idea.

Welcome to the invention of the directory.

Alan
