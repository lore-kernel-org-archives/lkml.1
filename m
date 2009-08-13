Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZHMRHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZHMRHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZHMRHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:07:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZHMRHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:07:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fischer, Anna" <anna.fischer@hp.com>
Subject: Re: [PATCH] net/bridge: Add 'hairpin' port forwarding mode
Date: Thu, 13 Aug 2009 19:06:21 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kaber@trash.net" <kaber@trash.net>,
       "Dickson, Mike (ISS Software)" <mike.dickson@hp.com>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "bridge@osdl.org" <bridge@osdl.org>
References: <0199E0D51A61344794750DC57738F58E6D6B0C70D9@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E6D6B0C70D9@GVW1118EXC.americas.hpqcorp.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131906.21916.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19YsopkFtqe0aGAGwP9pi4WeSfLsae7ogqu5Z6
 Ufq0yGV/aNDUyfAPyA7m8bmaYsTMdDKtKtbGaKB66zsG4cT0fN
 5IG6XBmFjHnTYlIsBCMQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Fischer, Anna wrote:
> This patch adds a 'hairpin' (also called 'reflective relay') mode
> port configuration to the Linux Ethernet bridge kernel module.
> A bridge supporting hairpin forwarding mode can send frames back
> out through the port the frame was received on.
> 
> Hairpin mode is required to support basic VEPA (Virtual
> Ethernet Port Aggregator) capabilities.
> 
> You can find additional information on VEPA here:
> http://tech.groups.yahoo.com/group/evb/
> http://www.ieee802.org/1/files/public/docs2009/new-hudson-vepa_seminar-20090514d.pdf
> http://www.internet2.edu/presentations/jt2009jul/20090719-congdon.pdf
> 
> An additional patch 'bridge-utils: Add 'hairpin' port forwarding mode'
> is provided to allow configuring hairpin mode from userspace tools.
> 
> Signed-off-by: Paul Congdon <paul.congdon@hp.com>
> Signed-off-by: Anna Fischer <anna.fischer@hp.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
