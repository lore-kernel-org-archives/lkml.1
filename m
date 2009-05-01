Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZEANTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZEANTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZEANTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:19:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37591 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756578AbZEANTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:19:15 -0400
Date: Fri, 1 May 2009 14:18:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-ID: <20090501141846.4b833700@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com>
References: <1241097822.2516.3.camel@poy>
	<20090430222900.c13b63d5.akpm@linux-foundation.org>
	<20090501061701.GB19234@kroah.com>
	<20090430234312.a63fa5cf.akpm@linux-foundation.org>
	<20090501065527.GA19773@kroah.com>
	<20090501120359.05bacb48@lxorguk.ukuu.org.uk>
	<ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No tool ever has a chance to get to the information only available at
> early kernel init. All such tools will need to "replay" what the
> kernel already did. This is intended to save us from doing this, and
> retain the information which is there, but lost at the moment the
> tools have the first chance to run.

Serious question - which is the better problem to fix ?

> It's not about a sucking tool, its just impossible. And there is no
> space wasted, it's a single string for a very few subsystems, an
> nothing is stored per device.

Plus code plus tmpfs nodes (the latter are not quite free because you
create unneeded ones versus udev but I agree that is noise for most users)
