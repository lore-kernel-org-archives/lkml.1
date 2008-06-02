Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYFBPiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYFBPiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYFBPiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:38:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47829 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbYFBPiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:38:05 -0400
X-Sasl-enc: iOY3B0sj8Mm7fPfBBIAVVlsybI+ZY/5CxC+7pNI12vIr 1212421082
Date: Mon, 2 Jun 2008 12:37:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Guntsche Michael <mike@it-loops.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Message-ID: <20080602153759.GA3406@khazad-dum.debian.net>
References: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com> <20080530065717.44cf7414@infradead.org> <F2473A1D-E4F5-4B9D-9538-B122553E1011@it-loops.com> <E234E250-922E-45F6-B01E-0B3CDC80A8ED@it-loops.com> <20080601185643.3d3db64f@infradead.org> <48435CCA.5000905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48435CCA.5000905@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jun 2008, Roger Heflin wrote:
> From my testing, I believe the only thing that p4-clockmod does is forces 
> an idle call when it could otherwise do work on an active process, so 
> fullspeed and idle uses *EXACTLY* the same amount of power as p4-clockmod 
> slower speed and idle (and therefore generates exactly the same amount of 
> heat), the only power difference would be that if you were using 
> p4-clockmod to slow down the cpu when it had an active running process 
> (force the cpu to be idle a lot of the time even though it has work).

Indeed.  And if we had a generic interface for throttling (ACPI
T-states-like) and frequency changes (ACPI P-states-like), we could just
move p4-clockmod to the throttling one (and NOT letting it register with
the frequency changes interface), and be done with it.

Do we have these interfaces?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
