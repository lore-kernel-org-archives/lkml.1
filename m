Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYHOOh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYHOOh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHOOhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:37:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44305 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753041AbYHOOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:37:16 -0400
Date: Fri, 15 Aug 2008 15:18:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: rmeijer@xs4all.nl
Cc: capibara@xs4all.nl, david@lang.hm, "Eric Paris" <eparis@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>,
       "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to	alinuxinterfaceforon
           access scanning
Message-ID: <20080815151855.4e9c2f09@lxorguk.ukuu.org.uk>
In-Reply-To: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This "permitted to execute" is what I feel is the wrong aproach with
> respect to malware. If you simply allow everything to 'execute', I think
> that untrusted programs may still be used for usefull things, but without
> the potential do do malice. If you start from the point where everything
> both trusted and untrusted  is permitted to be executed, you could make it
> the job of SELinux or any other LSM to make untrusted code run without
> doing malice, but with the possibility to still run and do usefull non
> malicious  stuff. This might require some aditional hooks in LSM though I
> could imagine.

SELinux is quite happy to apply different rules to content labelled in
different ways. WHat specific things do you need that it can't do ?
