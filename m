Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbYD2TFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbYD2TFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYD2TFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:05:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976AbYD2TFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:05:09 -0400
Date: Tue, 29 Apr 2008 12:02:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [27/37] tehuti: move ioctl perm check closer to function start
 (CVE-2008-1675)
In-Reply-To: <20080429185543.GA24643@suse.de>
Message-ID: <alpine.LFD.1.10.0804291200140.2997@woody.linux-foundation.org>
References: <20080429171222.073929148@mini.kroah.org> <20080429171901.GB14724@suse.de> <20080429191310.203384eb@core> <20080429185543.GA24643@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Apr 2008, Greg KH wrote:
>
> Hm, that's the way it is in Linus's tree, we should change it there
> first.

Done. It will be commit 6203554207728f43cfb9fd48585cd6500da73d42 when I 
push out (but please point to the original commit that actually adds the 
check: 6203554 just changes from CAP_NET_ADMIN to CAP_SYS_RAWIO and is not 
as important as adding the check in the first place.

(I don't know of anybody who actually really uses capabilities with 
individual bits, so I seriously doubt it matters)

		Linus
