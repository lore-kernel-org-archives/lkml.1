Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYE1UPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYE1UPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYE1UPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:15:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbYE1UPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:15:33 -0400
Date: Wed, 28 May 2008 14:35:10 -0400
From: Dave Jones <davej@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: S K <nospamnoham@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem activating multiple cores ONLY if I press any key
	before kernel is loaded
Message-ID: <20080528183510.GA10543@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Slaby <jirislaby@gmail.com>, S K <nospamnoham@gmail.com>,
	linux-kernel@vger.kernel.org
References: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com> <483A6F94.5070901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A6F94.5070901@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 10:06:44AM +0200, Jiri Slaby wrote:
 > On 05/26/2008 05:39 AM, S K wrote:
 > > and Fedora 9 with kernel 2.6.25.3-18.fc9.i686.
 > [...]
 > > I see this in dmesg:
 > > CPU 1 irqstacks, hard=c07ba000 soft=c079a000
 > > Not responding.
 > > Inquiring remote APIC #1...
 > > ... APIC #1 ID: failed
 > > ... APIC #1 VERSION: failed
 > > ... APIC #1 SPIV: failed
 > > CPU #1 not responding - cannot use it.
 > > Booting processor 1/2 ip 4000
 > > Not responding.
 > > Inquiring remote APIC #2...
 > > ... APIC #2 ID: failed
 > > ... APIC #2 VERSION: failed
 > > ... APIC #2 SPIV: failed
 > > CPU #2 not responding - cannot use it.
 > > Booting processor 1/3 ip 4000
 > > Not responding.
 > > Inquiring remote APIC #3...
 > > ... APIC #3 ID: failed
 > > ... APIC #3 VERSION: failed
 > > ... APIC #3 SPIV: failed
 > > CPU #3 not responding - cannot use it.
 > > Total of 1 processors activated (5015.39 BogoMIPS).
 > > ENABLING IO-APIC IRQs
 > > ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 > > Brought up 1 CPUs
 > 
 > Does it work with vanilla? If yes, contact your kernel provider (redhat bugzilla).

Incredibly high chance that the answer is yes.
I don't recall any patches that could affect this, and in honesty filing
this at rh bugzilla is going to make me scratch my head, and then
ask people here like tglx & ingo to take a look, so other than for tracking
purposes, it's not likely to improve chances of it getting fixed.

	Dave

-- 
http://www.codemonkey.org.uk
