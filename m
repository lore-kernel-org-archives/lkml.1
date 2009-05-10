Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZEJUam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZEJUam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 16:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZEJUac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 16:30:32 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2403 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZEJUac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 16:30:32 -0400
Subject: RFC: MAINTAINER email address style?
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1240557233.6735.240.camel@localhost>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz>
	 <1240415689.21848.19.camel@localhost>
	 <20090422185916.GA3864@uranus.ravnborg.org>
	 <20090422120510.cc17e470.akpm@linux-foundation.org>
	 <1240430185.21848.103.camel@localhost>  <20090422203005.GA467@elf.ucw.cz>
	 <1240557233.6735.240.camel@localhost>
Content-Type: text/plain
Date: Sun, 10 May 2009 13:26:40 -0700
Message-Id: <1241987200.3877.9.camel@Joe-AcerAspire>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 00:13 -0700, Joe Perches wrote: 
> On Wed, 2009-04-22 at 22:30 +0200, Pavel Machek wrote:
> > If possible, it would be nice to aggregate multiple entries onto one
> > line. I.e.:
> > P:      Len Brown
> > M:      len.brown@intel.com
> > P:      Pavel Machek
> > M:      pavel@ucw.cz
> > P:      Rafael J. Wysocki
> > M:      rjw@sisk.pl
> > L:      linux-pm@lists.linux-foundation.org
> > S:      Supported
> > 
> > ->
> > 
> > P:      Len Brown now <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Rafael J. Wysocki <rjw@sisk.pl>
> > L:      linux-pm@lists.linux-foundation.org
> > S:      Supported

Is there a consensus/majority opinion on this?

Should names and email addresses in MAINTAINERS be integrated?
Should it stay as-is or be changed to:

M: name <email>
M: name2 <email2>

or

M: name <email>, name2 <email2>

When multiple names are on a single line,
the M: line length can get relatively long.

The longest lines are 240 chars long.

240 M:  Ramkrishna Vepa <ram.vepa@neterion.com>, Rastapur Santosh <santosh.rastapur@neterion.com>, Sivakumar Subramani <sivakumar.subramani@neterion.com>, Sreenivasa Honnur <sreenivasa.honnur@neterion.com>, Anil Murthy <anil.murthy@neterion.com>
238 M:  "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Pekka Savola (ipv6) <pekkas@netcore.fi>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>
219 M:  Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesse Brandeburg <jesse.brandeburg@intel.com>, Bruce Allan <bruce.w.allan@intel.com>, PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>, John Ronciak <john.ronciak@intel.com>
185 M:  Ananth N Mavinakayanahalli <ananth@in.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Masami Hiramatsu <mhiramat@redhat.com>
167 M:  Steve Hodgson <shodgson@solarflare.com>, Ben Hutchings <bhutchings@solarflare.com>, Robert Stonehouse <rstonehouse@solarflare.com>, linux-net-drivers@solarflare.com
156 M:  Jeremy Fitzhardinge <jeremy@xensource.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
155 M:  Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bobcopeland.com>


