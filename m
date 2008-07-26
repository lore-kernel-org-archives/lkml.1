Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYGZW0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYGZW0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 18:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYGZW0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 18:26:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:46233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbYGZW0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 18:26:04 -0400
Date: Sun, 27 Jul 2008 00:25:59 +0200
From: Bernhard Walle <bwalle@suse.de>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: x86: move dma32_reserve_bootmem() after reserve_crashkernel()
Message-ID: <20080727002559.48cee0d4@kopernikus.site>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

can you send 91467bdf6e53058af13fd255375d6634ba0c70e0 (in
x86/crashdump) to Linus still for 2.6.27? I want that also in stable
for 2.6.26, and Greg KH stated that it must be first in Linus' tree.

(Although that commit cannot be applied to -stable directly because of
the huge code unification in 2.6.27 on the x86 side.)


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
