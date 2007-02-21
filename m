Return-Path: <linux-kernel-owner+w=401wt.eu-S1750935AbXBUXrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbXBUXrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXBUXry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:47:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:34883 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXBUXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OawHRq/43HQWSOKqodMhbAdfK5PuBybeLdKC1yZj6lHrDcmNyZhBsg0u5naFj3EM3QyDne/seMTxMy3cL6bSTgv5rGTJQDYYqxifriC7jGuMusRWTHuvuRZajqD1lKbZsfFvQ3l6TPYEr4fMNwslY83q5UqR0X0d2NZ4JSocnX8=
Message-ID: <45a44e480702211547h255c86dax82680c8f20df6d07@mail.gmail.com>
Date: Wed, 21 Feb 2007 18:47:52 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH 2.6.20 1/1] fbdev, mm: hecuba/E-Ink fbdev driver
Cc: "James Simmons" <jsimmons@infradead.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "Paul Mundt" <lethal@linux-sh.org>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>
In-Reply-To: <1172101416.4217.19.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217104215.GB25512@localhost> <1171715652.5186.7.camel@lappy>
	 <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
	 <20070217135922.GA15373@linux-sh.org>
	 <45a44e480702180331t7e76c396j1a9861f689d4186b@mail.gmail.com>
	 <20070218235741.GA22298@linux-sh.org>
	 <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
	 <Pine.LNX.4.62.0702200906070.2082@pademelon.sonytel.be>
	 <45a44e480702210855t344441c1xf8e081c82ece4e63@mail.gmail.com>
	 <1172101416.4217.19.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Wed, 2007-02-21 at 11:55 -0500, Jaya Kumar wrote:
> >
> > You are right. I will need that. I could put that into struct
> > fb_deferred_io. So drivers would setup like:
> >
>
> Is it also possible to let the drivers do the 'deferred_io'
> themselves?  Say, a driver that would flush the dirty pages on
> every VBLANK interrupt.

Yes, I think so. The deferred_io callback that the driver would get
would be to provide them with the dirty pages list. Then, they could
use that to handle the on-vblank work.

> > When the driver calls register_framebuffer and unregister_framebuffer,
> > I can then do the init and destruction of the other members of that
> > struct. Does this sound okay?
>
> It would be better if separate registering functions are created for
> this functionality (ie deferred_io_register/unregister).
>

Ok. Will do it that way.

Thanks,
jaya
