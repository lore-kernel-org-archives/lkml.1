Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZIOQE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZIOQE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZIOQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:04:52 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:46149 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZIOQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:04:51 -0400
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: Greg KH <gregkh@suse.de>
Subject: Re: unable to handle kernel NULL pointer / tty / 2.6.31-vanilla/ still persists
Date: Tue, 15 Sep 2009 19:06:14 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200909151032.53683.denys@visp.net.lb> <20090915150455.GA22282@suse.de>
In-Reply-To: <20090915150455.GA22282@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909151906.15043.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time i didnt  notice anything suspicious. From daemons - zebra, 
ssh/telnet, snmpd (net-snmp). Job - NAT/firewall, QoS (HFSC/HTB) and routing. 
Nothing else (it is semi-embedded system with busybox).

Sep 15 10:04:46 10.22.24.2 globax: [default][2846]B/G 0/100|buf 
1328692B+4478B/941P 69428216/942/74260 (globalproof1) spd 996330<1875000 sock 
128000>64000>64000 rtt 0.393943 delay 0 pps 705 so 0 st 0 dr
Sep 15 10:04:50 10.22.24.2 ripd[5017]: rip_read: cannot find interface for 
packet from 80.83.24.49 port 520
Sep 15 10:04:51 10.22.24.2 kernel: [273169.803628] BUG: unable to handle 
kernel NULL pointer dereference at (null)
Sep 15 10:04:51 10.22.24.2 kernel: [273169.803710] IP: [<c0250f08>] 
process_echoes+0x65/0x240
Sep 15 10:04:51 10.22.24.2 kernel: [273169.803785] *pdpt = 000000002f97d001 
*pde = 0000000000000000

Latest ssh bruteforce attempts was 10-20 minutes ago.

On Tuesday 15 September 2009 18:04:55 Greg KH wrote:
> On Tue, Sep 15, 2009 at 10:32:53AM +0300, Denys Fedoryschenko wrote:
> > Kernel 2.6.31-rc7
> > x86 , 32-bit
> > gcc 4.4.1
> >
> > Happened on heavy network load, looks like as previous one, seems problem
> > still persists.
> > It is hyperthreading Xeon, as i heard on such CPU's SMP bugs most easy to
> > trigger. But for me triggered after few days of operation.
> >
> > Here is oops:
>
> Ugh.
>
> What are you doing at the time of this happening?  What kind of load is
> on the system?
>
> thanks,
>
> greg k-h


