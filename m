Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZLAOKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZLAOKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZLAOKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:10:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55046 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZLAOKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hG7ctIUY/Oyrm1zoOT3unuxi6GBRCb7hBo1Vw00aARAhgXxksHnyiRjsph4QY/Kgg/
         KRllGb4532Lqst1GdZpEN7k/YOoogU/cQsZrZ7b6a6lV0mR4zsBuiCLcIEnwOyPBYTAx
         DRd7d6AlyDssUfauPKKLSvCjdr6ggS4H8qzyI=
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jonsmirl@gmail.com,
       dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       lirc-list@lists.sourceforge.net, mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <1259667480.3100.10.camel@palomino.walls.org>
References: <BE3edeNXqgB@lirc> <1259667480.3100.10.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 16:10:35 +0200
Message-ID: <1259676635.18599.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 06:38 -0500, Andy Walls wrote: 
> On Tue, 2009-12-01 at 08:45 +0100, Christoph Bartelmus wrote:
> > Hi Jon,
> > 
> > on 30 Nov 09 at 16:35, Jon Smirl wrote:
> 
> 
> > Currently I would tend to an approach like this:
> > - raw interface to userspace using LIRC
> > - fixed set of in-kernel decoders that can handle bundled remotes
> > 
> > That would allow zero configuration for simple use cases and full  
> > flexibility for more advanced use cases.
> > 
> > Christoph
> 
> I'd also prefer that approach.

I also agree with this approach.
This way, there will be no need for configfs hacks, but just static
table for bundled remotes, and in fact this is very clean approach.
Also, since bundled remotes use standard protocols, there will be no
problem to add decoders for them.

For the rest, the remotes that were never meant to be used with the
computer, lircd will do just fine.

So, it a deal?

Best regards,
Maxim Levitsky



