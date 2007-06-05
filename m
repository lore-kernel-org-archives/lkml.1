Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbXFEL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbXFEL0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXFEL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:26:42 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:63876 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbXFEL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P9AgOGSx3+KPnciZ22Vr5HXQIju3yHrsSJ082RUDyrb+J52T6l+LmeEFboF+UhuZ6LctVRvTH1VgJCMK3ygSH9QvvC5kBQvtfd5sRO5mvkKPoYctexKUUX3sx4b2B3OzZfYJ9TzaPZEvIfje4a9prYlYU2BnQI5nWFSD4AeJ3Kw=
Subject: Re: Section mismatches in drivers/video/console/promcon
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, jakub@redhat.com, jengelh@linux01.gwdg.de,
       daplas@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070604.235313.85409993.davem@davemloft.net>
References: <20070602124255.GA10119@uranus.ravnborg.org>
	 <1180790683.4524.13.camel@daplas>
	 <20070602191646.GA13264@uranus.ravnborg.org>
	 <20070604.235313.85409993.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 18:52:53 +0800
Message-Id: <1181040773.5023.5.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 23:53 -0700, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 2 Jun 2007 21:16:46 +0200
> 
> > > 
> > > promcon_init() can be called again from visual_init() during
> > > vc_allocate().  So anything referenced by promcon_init() should not be
> > > marked __init.
> > > 
> > > Although, if you want to keep promfont_unitable and promfont_unicount
> > > __init, you can probably use con_copy_unimap() using the default vc as
> > > the source instead of doing a promcon_init_unimap() again.
> > 
> > Too involved for me to look into.
> > I cooked up following very minimal patch - if you agree can you then please
> > forward/take care of it.
> > 
> > 	Sam
> > 
> > Subject: video: fix section mismatch warning in promcon
> 
> I'll merge this fix in via the Sparc tree since this is a sparc
> console driver.
> 

I was about to send this patch to akpm, I'll leave this to you then.

Tony


