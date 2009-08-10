Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZHJPXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZHJPXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbZHJPXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:23:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZHJPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:23:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: evb@yahoogroups.com
Subject: Re: [evb] Re: [PATCH][RFC] net/bridge: add basic VEPA support
Date: Mon, 10 Aug 2009 17:23:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "'Stephen Hemminger'" <shemminger@linux-foundation.org>,
       "'Fischer, Anna'" <anna.fischer@hp.com>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       davem@davemloft.net, kaber@trash.net, adobriyan@gmail.com,
       "'Or Gerlitz'" <ogerlitz@voltaire.com>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net> <200908071329.44437.arnd@arndb.de> <005101ca1797$70dcf5b0$5296e110$@edu>
In-Reply-To: <005101ca1797$70dcf5b0$5296e110$@edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101723.10832.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tMjzdJ+zANWS93lASAeBW40MH5Wp9y64crEU
 JVajfvxPTw9MvAi6dVmkXB8fCz2fCgvPNmnlowf+RbwvIzy+gB
 DBns3REh+QiaEMa95Yf+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Paul Congdon (UC Davis) wrote:
> 
> I don't think your scheme works too well because broadcast packet coming
> from other interfaces on br0 would get replicated and sent across the wire
> to ethB multiple times.

Right, that won't work. So the bridge patch for the hairpin turn
is still the best solution. Btw, how will that interact with
the bride-netfilter (ebtables) setup? Can you apply any filters
that work on current bridges also between two VEPA ports while
doing the hairpin turn?

	Arnd <><
