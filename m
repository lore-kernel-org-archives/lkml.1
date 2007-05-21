Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXEUS75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXEUS75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbXEUS7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:59:50 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:60534 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbXEUS7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:59:49 -0400
Date: Mon, 21 May 2007 20:59:47 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070521185947.GF14802@vanheusden.com>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <46517817.1080208@users.sourceforge.net> <20070521110406.GA14802@vanheusden.com> <Pine.LNX.4.61.0705211420100.4452@yvahk01.tjqt.qr> <20070521124734.GB14802@vanheusden.com> <4651A564.9090509@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4651A564.9090509@users.sourceforge.net>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue May 22 12:32:47 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> What about the following enhancement: I check with sig_fatal if it would
> >>> kill the process and only then emit a message. So when an application
> >>> takes care itself of handling it nothing is printed.
> >>> +	/* emit some logging for unhandled signals
> >>> +	 */
> >>> +	if (sig_fatal(t, sig))
> >> Not unhandled_signal()?
> > Can we already use that one in send_signal? As the signal needs to be
> > send first I think before we know if it was handled or not? sig_fatal
> > checks if the handler is set to default - which is it is not taken care
> > of.
> What about ptrace()'d processes? I don't think we should log signals for them...

Why not?


Folkert van Heusden

-- 
MultiTail es una herramienta flexibele para consiguir archivos de log,
y para ejecutar ordenes. Filtrar, añadir colores, merger y vista de
las differencias.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
