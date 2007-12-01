Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbXLAAG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbXLAAG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbXLAAGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:06:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759891AbXLAAGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:06:09 -0500
Date: Fri, 30 Nov 2007 22:05:45 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bill Davidsen <davidsen@tmr.com>, David Newall <david@davidnewall.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Xavier Bestel <xavier.bestel@free.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071201000545.GI30008@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Bill Davidsen <davidsen@tmr.com>,
	David Newall <david@davidnewall.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Xavier Bestel <xavier.bestel@free.fr>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
References: <474EAD18.6040408@stellatravel.co.uk> <1196416960.20567.205.camel@skunk.anacadf.mentorg.com> <20071130190742.4B7C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1196418013.20567.211.camel@skunk.anacadf.mentorg.com> <Pine.LNX.4.64.0711301154070.3089@fbirervta.pbzchgretzou.qr> <47501C86.1020907@davidnewall.com> <47509D56.7010605@tmr.com> <20071130234013.446f14ef@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130234013.446f14ef@the-village.bc.nu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 30, 2007 at 11:40:13PM +0000, Alan Cox escreveu:
> > BCPL was typeless, as was the successor B (between Bell Labs and GE we 
> 
> B isn't quite typeless. It has minimal inbuilt support for concepts like
> strings (although you can of course multiply a string by an array
> pointer ;))
> 
> It also had some elegances that C lost, notably 
> 
> 	case 1..5:

Hey, the language we use, gcC has this too 8-)

[acme@doppio net-2.6.25]$ find . -name "*.c" | xargs grep 'case.\+\.\.' | wc -l
400
[acme@doppio net-2.6.25]$ find . -name "*.c" | xargs grep 'case.\+\.\.' | head
./kernel/signal.c:      default: /* this is just in case for now ... */
./kernel/audit.c:       case AUDIT_FIRST_USER_MSG ...  AUDIT_LAST_USER_MSG:
./kernel/audit.c:       case AUDIT_FIRST_USER_MSG2 ...  AUDIT_LAST_USER_MSG2:
./kernel/audit.c:       case AUDIT_FIRST_USER_MSG ...  AUDIT_LAST_USER_MSG:
./kernel/audit.c:       case AUDIT_FIRST_USER_MSG2 ...  AUDIT_LAST_USER_MSG2:
./kernel/timer.c:        * well, in that case 2.2.x was broken anyways...
./arch/frv/kernel/traps.c:      case TBR_TT_TRAP2 ... TBR_TT_TRAP126:
./arch/frv/kernel/ptrace.c:             case 0 ... PT__END - 1:
./arch/frv/kernel/ptrace.c:             case 0 ... PT__END-1:
./arch/frv/kernel/gdb-stub.c:                   case GDB_REG_GR(1) ...  GDB_REG_GR(63):
[acme@doppio net-2.6.25]$

- Arnaldo
