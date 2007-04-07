Return-Path: <linux-kernel-owner+w=401wt.eu-S965449AbXDGH2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbXDGH2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 03:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXDGH2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 03:28:40 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:57306 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965449AbXDGH2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 03:28:39 -0400
Message-ID: <46174825.4050509@gmail.com>
Date: Sat, 07 Apr 2007 09:28:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Char: cyclades, remove volatiles
References: <16309194841640222796@karneval.cz>	<25307199761334218148@karneval.cz> <20070406171406.317ea28a.akpm@linux-foundation.org>
In-Reply-To: <20070406171406.317ea28a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Wed,  4 Apr 2007 23:45:38 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> cyclades, remove volatiles
> 
> The other changes seem uncontroversial, but this one has the potential
> to change runtime behaviour.  And cyclades.c is a driver which some people
> actually use ;)

Well, don't you know anybody with Z card, please?

But all volatiles were
- used locally (loop variables, nonptr count read once from HW), so that nothing
has a chance to change them in the memory.
- accessed by readX/writeX (pointers to mapped HW) and that should be OK

> Have these changes been runtime-tested?

Yes this time :), I have at least PCI Y cyclades card within reach to test.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
