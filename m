Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZHLMx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZHLMx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZHLMx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:53:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZHLMxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:53:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
Date: Wed, 12 Aug 2009 14:52:01 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       "Andrew Morton" <akpm@linux-foundation.org>, hpa@zytor.com,
       Patrick Mullaney <pmullaney@novell.com>
References: <20090811212743.GA26309@redhat.com> <20090812120541.GA29158@redhat.com> <4A82B87B.4010208@gmail.com>
In-Reply-To: <4A82B87B.4010208@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121452.01802.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+S7tkmd2U3APq7+0t1qQdr0tsEku+VckZcH2j
 LRXVp9+XwCOlTQBqlTpODpsZyVsa18Jzr1WhJKCuYnctlxIyI7
 GsJvQzELzpTvq+Apsz2Lg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Gregory Haskins wrote:
> >> Are you saying SRIOV is a requirement, and I can either program the
> >> SRIOV adapter with a mac or use promis?  Or are you saying I can use
> >> SRIOV+programmed mac OR a regular nic + promisc (with a perf penalty).
> > 
> > SRIOV is not a requirement. And you can also use a dedicated
> > nic+programmed mac if you are so inclined.
> 
> Makes sense.  Got it.
> 
> I was going to add guest-to-guest to the test matrix, but I assume that
> is not supported with vhost unless you have something like a VEPA
> enabled bridge?
> 

If I understand it correctly, you can at least connect a veth pair
to a bridge, right? Something like

           veth0 - veth1 - vhost - guest 1 
eth0 - br0-|
           veth2 - veth3 - vhost - guest 2
          
It's a bit more complicated than it need to be, but should work fine.

	Arnd <><
