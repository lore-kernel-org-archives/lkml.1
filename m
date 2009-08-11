Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZHKOzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZHKOzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbZHKOzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:55:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:26110 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbZHKOzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:55:02 -0400
From: "Paul Congdon \(UC Davis\)" <ptcongdon@ucdavis.edu>
To: "'Fischer, Anna'" <anna.fischer@hp.com>, "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Stephen Hemminger'" <shemminger@linux-foundation.org>,
       <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <evb@yahoogroups.com>, <davem@davemloft.net>, <kaber@trash.net>,
       <adobriyan@gmail.com>, "'Eric Biederman'" <ebiederm@xmission.com>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net> <200908081149.27409.arnd@arndb.de> <0199E0D51A61344794750DC57738F58E6D6AE99743@GVW1118EXC.americas.hpqcorp.net> <200908101707.32751.arnd@arndb.de> <0199E0D51A61344794750DC57738F58E6D6AE99C53@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E6D6AE99C53@GVW1118EXC.americas.hpqcorp.net>
Subject: RE: [PATCH][RFC] net/bridge: add basic VEPA support
Date: Tue, 11 Aug 2009 07:55:04 -0700
Message-ID: <001001ca1a93$b6e50ee0$24af2ca0$@edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcoZzGNIi2plXMD8SC2GLFrPuLsDmAAwiOTgAAExvSA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > The patch from Eric Biederman to allow macvlan to bridge between
> > its slave ports is at
> >
> > http://kerneltrap.org/mailarchive/linux-netdev/2009/3/9/5125774
> 
> Looking through the discussions here, it does not seem as if a decision
> was made to integrate those patches, because they would make the
> macvlan
> interface behave too much like a bridge. Also, it seems as if there was
> still a problem with doing multicast/broadcast delivery when enabling
> local VM-to-VM communication. Is that solved by now?
> 

Also, is there a solution, or plans for a solution, to address macvtap
interfaces that are set to 'promiscuous' mode?  It would seem fairly easy to
support this for interfaces that are simply trying to listen to the port
(e.g. Wireshark).  If the port was being used by something like a firewall
then the VEPA filtering doesn't work too well.

Paul


