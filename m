Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYDGJNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYDGJNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYDGJNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:13:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53760 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448AbYDGJNf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:13:35 -0400
Message-Id: <1207559615.27658.1246448421@webmail.messagingengine.com>
X-Sasl-Enc: 0Yw28UO3MjwuIDXd4McimEOKiM25nMlzrw8FC0QmhHHt 1207559615
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080406124700.GA26669@mailshack.com> <20080407074614.GD2368@elte.hu>
Subject: Re: [PATCH] x86: remove superfluous initialisation in boot code.
In-Reply-To: <20080407074614.GD2368@elte.hu>
Date: Mon, 07 Apr 2008 11:13:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 7 Apr 2008 09:46:14 +0200, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
> > --- a/arch/x86/boot/compressed/misc.c
> > +++ b/arch/x86/boot/compressed/misc.c
> > @@ -223,7 +223,7 @@ static memptr free_mem_end_ptr;
> >  #define HEAP_SIZE             0x4000
> >  #endif
> >  
> > -static char *vidmem = (char *)0xb8000;
> > +static char *vidmem;
> >  static int vidport;
> 
> thanks, applied. (Btw., you forgot your signoff line - not a big deal 
> for a small fix like this but it's best to always include it for patches 
> you'd like to see go upstream.)

Hmm... I knew I had forgotten something. So I did another round of tests
to see if it was working correctly :-/.

If you like, you can add:
Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

Greetings,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - And now for something completely different…

