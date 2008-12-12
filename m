Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYLLLAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYLLLAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYLLLAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:00:00 -0500
Received: from mx01.qsc.de ([213.148.129.14]:56438 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195AbYLLK76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:59:58 -0500
Message-ID: <49424425.4070205@wizards.de>
Date: Fri, 12 Dec 2008 11:59:49 +0100
From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?= <holger@wizards.de>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Manfred Spraul <manfred@colorfullife.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Nasty regression from .27.7 to .27.8: idle samba goes
 crazy
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de> <20081208222246.GA29232@sith.mimuw.edu.pl> <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com> <493FFE5E.2000404@colorfullife.com> <49419A14.50402@wizards.de> <20081211234041.GA1119@kroah.com>
In-Reply-To: <20081211234041.GA1119@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Dec 11, 2008 at 11:54:12PM +0100, Holger Hoffstätte wrote:
> [samba's smbd going into spin of death after client disconnect]
> 
> .9-rc1 does contain a cifs patch, so perhaps that resolved the issue for
> you.

I spoke too soon: no, it didn't help as it happened again last night. I
don't see how CIFS oculd have helped, as userlevel smbd has AFAIK nothing
to do with the CIFS kernel module?

Apparently only pulling the client cable does NOT provoke the bug (tried
several times), whereas putting the client box into sleep mode does
(though that worked at least once as well). This time it also didn't
reboot properly without hard power-off. :/

Now running with Manfred's patch to idr.c; will report back if it happens
again.

Holger
