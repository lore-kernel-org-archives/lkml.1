Return-Path: <linux-kernel-owner+w=401wt.eu-S965628AbXBOLQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965628AbXBOLQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965645AbXBOLQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:16:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965628AbXBOLQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:16:16 -0500
Date: Thu, 15 Feb 2007 06:15:59 -0500
From: Dave Jones <davej@redhat.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Mohammed Gamal <m.gamal005@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070215111559.GA8353@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Xavier Bestel <xavier.bestel@free.fr>,
	Mohammed Gamal <m.gamal005@gmail.com>, linux-kernel@vger.kernel.org
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070214231143.11ff6b46.rdunlap@xenotime.net> <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com> <1171533690.5835.40.camel@frg-rhel40-em64t-03> <52d4a3890702150251w7751da0cve55c6f2cf64e1b8e@mail.gmail.com> <1171537256.5835.60.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171537256.5835.60.camel@frg-rhel40-em64t-03>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 12:00:56PM +0100, Xavier Bestel wrote:
 > On Thu, 2007-02-15 at 12:51 +0200, Mohammed Gamal wrote:
 > > I am still a kernel newbie, and I am still not very much aware about
 > > the GPL vs. Non-GPL drivers debate. I personally think it'd be better
 > > that all drivers should be GPL'd but if that's the case, what would be
 > > the legal position of such vendors as ATI or NVIDIA who supply closed
 > > source drivers? Would it be illegal to use them?
 > 
 > Yeah, this is a recurrent debate, and the positions are mixed. Linus
 > said that the nvidia driver isn't developed only for linux but also for
 > windows, so it's not a true derivative of the kernel, so the GPL doesn't
 > really apply. But not everyone (I mean core developpers) fully agrees
 > IIRC.

to further expand on the above question it isn't really crystal clear
whether this (from the ATI driver) is legal..
(psuedo diff vs the kernel agp drivers)



+#ifdef STANDALONE_AGPGART
 MODULE_AUTHOR("Jeff Hartmann <jhartmann@precisioninsight.com>");
 MODULE_PARM(agp_try_unsupported, "1i");
 #ifdef MODULE_LICENSE
 MODULE_LICENSE("GPL and additional rights");
+#endif


and then linking the result to their binary blob.
I assume ATI's lawyers think its legal, as it's been a year and
a half since I first brought this questionable act to their
attention.

		Dave

-- 
http://www.codemonkey.org.uk
