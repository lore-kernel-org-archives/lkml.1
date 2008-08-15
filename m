Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYHOLVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYHOLVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYHOLVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:21:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50959 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752662AbYHOLVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:21:15 -0400
Date: Fri, 15 Aug 2008 12:02:25 +0100
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
Message-ID: <20080815120225.118d81da@lxorguk.ukuu.org.uk>
In-Reply-To: <8676.82.95.100.23.1218795012.squirrel@webmail.xs4all.nl>
References: <8676.82.95.100.23.1218795012.squirrel@webmail.xs4all.nl>
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

> The package manager approach is interesting in that it marks 'trusted',
> and is thus permissive rather than restrictive. Maybe it would be possible
> to extend on this and simply define a set of currently unprivileged access
> as privileged for untrusted applications. That way you could allow
> untrusted software to run without risk, even if that untrusted software
> turns out to be malware. That is, it may be possible to solve the malware
> problem in a much more fundamental way here by just allowing malware to
> run without the need to know if it is malware, just by running untrusted
> software with reduced privileges.
> 

Its called SELinux and SELinux can already do this sort of stuff,
including things like "only rpm may create files you are permitted to
execute"
