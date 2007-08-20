Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbXHTIuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbXHTIuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXHTIub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:50:31 -0400
Received: from mx1.wp.pl ([212.77.101.5]:9022 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbXHTIub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:50:31 -0400
Date: Mon, 20 Aug 2007 10:50:28 +0200
From: "Krzysztof Helt" <krzysztof.h1@wp.pl>
To: Markus Dahms <mad@automagically.de>
Cc: sparclinux <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Odp: possible endless loop in PROM initialization
Message-ID: <46c955d43d407@wp.pl>
References: <20070820075949.GA5927@vimes.madsworld.lan>
In-reply-to: <20070820075949.GA5927@vimes.madsworld.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Mailer: Interfejs WWW poczty Wirtualnej Polski
Organization: Poczta Wirtualnej Polski S.A. http://www.wp.pl/
X-User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1) Gecko/20061025 Firefox/2.0
X-WP-IP: 83.17.101.58
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000                                      
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 20-08-2007 o godz. 9:59 Markus Dahms napisa³(a):
> Hey,
> 
> while trying to define a non-unique devalias at the Sun PROM prompt
> (the SPARCclassic X has wrong aliases for scsi, disk1, etc. in the
> PROM, at least mine) I fell over a bug resulting in an endless loop
> while booting the kernel.
> 
> The problem is the getting the properties list of the /aliases
node.
> As the next element in this list is identified by name and the
> function which retrieves this property always returns the first
> occurrence this goes forever....
>

Could you give name of the function which contains this endless loop?
When I looked into the tree.c file for the first time I thought
it had a bug
in handling the prom_nextprop, but later I concluded that this is ok.
Maybe there is a bug there after all.

Regards,
Krzysztof

----------------------------------------------------
Wielka siatkówka we wrze¶niu w Starych Jab³onkach
zobacz gwiazdy siatkówki pla¿owej na ¿ywo! 
Mistrzostwa ¦wiata w siatkówce pla¿owej 5-9.09.2007
Kliknij: http://klik.wp.pl/?adr=http%3A%2F%2Fadv.reklama.wp.pl%2Fas%2Fstarejablonki.html&sid=1262


