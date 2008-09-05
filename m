Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYIEOtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYIEOtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYIEOs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:48:56 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:37865 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbYIEOs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:48:56 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: frame unwinder patches
Date: Fri, 5 Sep 2008 16:48:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
References: <g9p3du$n95$1@ger.gmane.org> <200809051552.47929.bs@q-leap.de> <20080905071337.3373ab86@infradead.org>
In-Reply-To: <20080905071337.3373ab86@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051648.52767.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2008 16:13:37 Arjan van de Ven wrote:
> On Fri, 5 Sep 2008 15:52:47 +0200
>
> Bernd Schubert <bs@q-leap.de> wrote:
> > > (and if you really care it's 1 line of code to turn it off)
> >
> > It is not only this, I think the dwarf2 stack unwinder patches
> > provide by far better traces than the in-kernel unwinder. At least
> > ever since I applied these patches to our kernels, I was able to read
> > the stack dumps...
>
> they really wouldn't be different than the ones you get if you remove
> the "?" lines.

Well may be, but then there is still the performace degrading, so I don't want 
to have it enabled on our production kernels. I admit I never measured what 
is the difference between of CONFIG_FRAME_POINTER=y and =n, but the fact the 
help text says there is a difference already makes me want to disable it 
(especially, since we have to provide benchmarks before we can sell a 
system).


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
