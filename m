Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXCGKBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXCGKBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXCGKBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:01:42 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:59575 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbXCGKBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:01:41 -0500
Date: Wed, 7 Mar 2007 11:02:58 +0100
From: DervishD <lkml@dervishd.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070307100258.GA30270@DervishD>
Mail-Followup-To: "Antonino A. Daplas" <adaplas@gmail.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>
References: <20070226144744.GA3615@DervishD> <1172503471.20842.14.camel@daplas> <20070226171334.GB13496@DervishD> <1172510654.7101.11.camel@daplas> <20070226203223.GA161@DervishD> <1172617755.13422.0.camel@daplas> <20070301160139.GA102@DervishD> <1173144817.7219.1.camel@daplas> <20070306062528.GF20292@DervishD> <1173164006.6285.8.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1173164006.6285.8.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Antonino :)

 * Antonino A. Daplas <adaplas@gmail.com> dixit:
> On Tue, 2007-03-06 at 07:25 +0100, DervishD wrote:
> > > >     If you want me to test other patches, just tell :)
> > > 
> > > Can you change the mdelay to udelay and use higher/lower delay values
> > > to see if there's any improvement?

    Regarding the delay: I've discovered a weird thing. When the display
is garbled, if I insist on outputting more text to the screen, sooner or
later it de-garbles! In fact, once the display has been garbled (not
easy to do, sometimes I can work for hours in a terminal before it gets
garbled, I can't reproduce it always), a continous output makes it
de-garble and garble again, in cycles.

    Looks like an off-by-one error rather than a speed/sync error, am I
completely clueless?

    This happens with vanilla 2.6.19.5, not with the patched one, which
I haven't been able to test yet (sorry...).

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
