Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbZF2QhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbZF2QhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZF2QhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:37:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZF2QhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:37:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Move of_node_to_nid to generic location
Date: Mon, 29 Jun 2009 18:36:50 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: monstr@monstr.eu, benh@kernel.crashing.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, linux@arm.linux.org.uk
References: <4A4884D6.3090404@monstr.eu> <fa686aa40906290852g42f55390tae7148e08fb8efe3@mail.gmail.com>
In-Reply-To: <fa686aa40906290852g42f55390tae7148e08fb8efe3@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906291836.51183.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18lxk9+ez/E0l3AEKzqJwiJqrLd62eG9jKenJh
 fQR4kXJbizKRQAI433NFRXA7Zr4d8MEjiokePd1FKDdNbBGoUZ
 5IVMR6Aqoji8Nay55kBpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Grant Likely wrote:
> On Mon, Jun 29, 2009 at 3:09 AM, Michal Simek<monstr@monstr.eu> wrote:
> > Hi All,
> >
> > I have on my list one task which needs to be discuss with you.
> > I look at of_node_to_nid for non NUMA systems. I think we should
> > move this function to asm-generic/topology.h.
> 
> I'm in the process of moving a bunch of stuff out of the various
> prom.c files and into drivers/of/*.c.  If this is a common function,
> then I think it should go there.

I agree, it fits better into one of the 'of' headers than the topology
header. Maybe include/linux/of_device.h or include/linux/of.h?

	Arnd <><
