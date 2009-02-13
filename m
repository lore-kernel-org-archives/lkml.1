Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZBMJml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZBMJml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZBMJmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:42:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbZBMJmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:42:32 -0500
Date: Fri, 13 Feb 2009 10:42:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090213094200.GC17774@elte.hu>
References: <20090213093354.GA10175@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213093354.GA10175@denkbrett.schottelius.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:s added - post-rc4 ACPI breakage.)

* Nico Schottelius <nico-linux-20090213@schottelius.org> wrote:

> Hello!
> 
> When using
>   - vmlinuz-2.6.29-rc4-ikn-00058-g4c098bc or
>   - vmlinuz-2.6.29-rc4-ikn-00211-g37bed90
> 
> the brightness of the LCD is almost off (lowest level),
> although kernel reports otherwise:
> 
> [10:31] ikn:~% cat /proc/acpi/video/VID/LCD0/brightness 
> levels:  20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 100
> current: 100
> 
> Changing the brightness via echo 20 > /proc/acpi/video/VID/LCD0/brightness
> only changes the value displayed, the display always keeps the same
> brightness.
> 
> The last time I saw it working was vmlinuz-2.6.29-rc4-ikn-00001-gd5b5623.
> 
> Sincerly,
> 
> Nico
> 
> ps: please CC on reply
> 
> -- 
> Think about Free and Open Source Software (FOSS).
> http://nico.schottelius.org/documentations/foss/the-term-foss/
> 
> PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C


