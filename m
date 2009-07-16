Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZGPIlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZGPIlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZGPIlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:41:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55840 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753725AbZGPIln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:41:43 -0400
Date: Thu, 16 Jul 2009 09:41:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <greg@kroah.com>, Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
Message-ID: <20090716094135.4e6c9ba0@lxorguk.ukuu.org.uk>
In-Reply-To: <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	<1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	<20090714161514.GA2026@kroah.com>
	<21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't have a device in this case, vga arb is more of an abstraction than
> an actual device.
> 
> I suppose if we were feeling crazy we could add a platform device for it.

Probably a good idea and it gives you something more meaningful to hang
the list of devices being arbitrated.

Alan
