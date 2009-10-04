Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZJDO5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZJDO5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 10:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZJDO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 10:57:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38184 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbZJDO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 10:57:38 -0400
Date: Sun, 4 Oct 2009 15:58:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matteo Croce <technoboy85@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091004155802.421b5f93@lxorguk.ukuu.org.uk>
In-Reply-To: <20091003192524.2ca2bd9e@infradead.org>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
	<20091003110546.78958508@infradead.org>
	<40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>
	<20091003192524.2ca2bd9e@infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm surprised that "i686" in debian depends on the family flag
> in /proc/cpuinfo.. but hey.. weirder things have been done.

Its compensating for the old gcc bugs where gcc "i686" generated cmov
instructions without any checks whether the CPU supported cmov (which is
optional for a 686 architecture)

RPM has (or had) similar hacks. Both arguably come about from fundamental
design thinkos in that they treat architecture as "special", not simply
as a set of dependancies (needs x86, x86-cmov, glibc x86-32, ...) as
should hve been done and which would also have made emulators just work
out of the box instead of the current mess.

Alan
