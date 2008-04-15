Return-Path: <linux-kernel-owner+w=401wt.eu-S1763410AbYDOBLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763410AbYDOBLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYDOBLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:11:23 -0400
Received: from khc.piap.pl ([195.187.100.11]:38744 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbYDOBLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:11:22 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Marc Perkel <mperkel@yahoo.com>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <47FFD3F3.50107@redhat.com>
	<821384.64293.qm@web52504.mail.re2.yahoo.com>
	<20080411213843.GH2160@csclub.uwaterloo.ca>
	<4802608A.3040901@zytor.com>
	<20080414151222.GF7385@csclub.uwaterloo.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 15 Apr 2008 03:11:20 +0200
In-Reply-To: <20080414151222.GF7385@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Mon\, 14 Apr 2008 11\:12\:22 -0400")
Message-ID: <m3prsrj51j.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> True, but usually they give you an option to turn it off in the BIOS to
> make the system actually work with things like NTP.
>
> Maybe I should have said "Any system with spread spectrum enabled".

I haven't investigated those spread spectrums at all but sometimes
there are options: "center" (the frequency is centered around the
nominal value, I guess) and "below" (or something like that). If done
correctly, "center" shouldn't have visible effect on NTP, should it?

The other important question is "what frequency has spread spectrum
enabled"? CPU (= TSC), HPET, RAM, something else?
-- 
Krzysztof Halasa
