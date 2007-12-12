Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbXLLM13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbXLLM13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXLLM1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:27:21 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59668 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbXLLM1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:27:21 -0500
X-Greylist: delayed 1817 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 07:27:20 EST
Date: Wed, 12 Dec 2007 13:57:01 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212115701.GC16513@sci.fi>
References: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 12:31:18AM +0100, Rene Herman wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run 
> the attached program? This is about testing how long I/O port access to 
> port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in 
> reporting.

vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping        : 6

cpu MHz         : 2394.000
cycles: out 1830, in 1166

cpu MHz         : 1596.000
cycles: out 1925, in 1266

##

vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 10

cpu MHz         : 850.000
cycles: out 1142, in 475

cpu MHz         : 700.000
cycles: out 914, in 406

##

vendor_id       : AuthenticAMD
cpu family      : 6
model           : 7
model name      : AMD Duron(tm) processor
stepping        : 1

cpu MHz         : 1300.108
cycles: out 2562, in 2562

##

vendor_id       : GenuineIntel
cpu family      : 6
model           : 5
model name      : Pentium II (Deschutes)
stepping        : 2

cpu MHz         : 449.242
cycles: out 607, in 272

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
