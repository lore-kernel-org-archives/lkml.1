Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbXEIOv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbXEIOv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXEIOvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:51:23 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:17269 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXEIOvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cM3l1bOaGAGGuVTr3jS84HbW6024MbkaZu4pIj1IcqcYYhJlt//tVfs+Qmba3n2+ElFYS9+VV5nfY00aWSVhJSwMFHt/TtwfqVK9MAF73+/RpuXR8XeQqxo0wQ9x5tB4XdUdF7mcnQ4YHiX5YuisLKqv+7lZQlyqObKUOq4u8NM=
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070509143018.GH8753@csclub.uwaterloo.ca>
References: <20070505104452.GA30944@mailshack.com>
	 <20070508032817.e4734798.akpm@linux-foundation.org>
	 <20070508183232.GA13225@mailshack.com> <1178669047.4747.15.camel@daplas>
	 <20070509143018.GH8753@csclub.uwaterloo.ca>
Content-Type: text/plain
Date: Wed, 09 May 2007 22:51:14 +0800
Message-Id: <1178722274.4861.29.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 10:30 -0400, Lennart Sorensen wrote:
> On Wed, May 09, 2007 at 08:04:07AM +0800, Antonino A. Daplas wrote:
> > On Tue, 2007-05-08 at 20:32 +0200, Alexander van Heukelum wrote:
> > > On Tue, May 08, 2007 at 03:28:17AM -0700, Andrew Morton wrote:
> > > > On Sat, 5 May 2007 12:44:52 +0200 Alexander van Heukelum <heukelum@mailshack.com> wrote:

> > > @@ -95,7 +95,8 @@ #define PARAM_VESAPM_SEG	0x2e
> > >  #define PARAM_VESAPM_OFF	0x30
> > >  #define PARAM_LFB_PAGES		0x32
> > >  #define PARAM_VESA_ATTRIB	0x34
> > > -#define PARAM_CAPABILITIES	0x36
> > > +#define PARAM_VESA_PAD		0x36
> > > +#define PARAM_CAPABILITIES	0x38
> 
> Isn't this ^^^ what you are suggesting below?
> 

Yes, sorry, why did I miss that one :-)

Tony

