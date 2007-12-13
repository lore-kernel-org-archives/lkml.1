Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXLMQmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXLMQmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbXLMQmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:42:44 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:32928 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbXLMQmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:42:43 -0500
Date: Thu, 13 Dec 2007 18:42:40 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071213164240.GA15861@sci.fi>
References: <475F1DC6.5090403@keyaccess.nl> <20071212115701.GC16513@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071212115701.GC16513@sci.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 01:57:01PM +0200, Ville Syrjälä wrote:
> On Wed, Dec 12, 2007 at 12:31:18AM +0100, Rene Herman wrote:
> > Good day.
> >
> > Would some people on x86 (both 32 and 64) be kind enough to compile and run 
> > the attached program? This is about testing how long I/O port access to 
> > port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in 
> > reporting.
> 
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> stepping        : 6
> 
> cpu MHz         : 2394.000
> cycles: out 1830, in 1166
> 
> cpu MHz         : 1596.000
> cycles: out 1925, in 1266

BTW that was my home desktop. I just noticed that my work desktop gives out
significantly different results.

vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz
stepping        : 6

cpu MHz         : 2667.000
cycles: out 4263, in 2487

cpu MHz         : 1600.000
cycles: out 4391, in 2623

There seems to be more variation in the results between runs on this system
too. I suppose the difference must be up to the chipset.

My home system:
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 02)
00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface Controller (rev 02)

My work system:
00:00.0 Host bridge: Intel Corporation 82975X Memory Controller Hub
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
