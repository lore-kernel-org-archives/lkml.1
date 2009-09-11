Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZIKBgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZIKBgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZIKBgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:36:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:51380 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZIKBgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:36:35 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>, realnc@arcor.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200909091355.56335.elendil@planet.nl>
References: <20090906205952.GA6516@elte.hu>
	 <200909082222.44828.elendil@planet.nl> <1252489988.26522.46.camel@pasglop>
	 <200909091355.56335.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 11:36:21 +1000
Message-Id: <1252632981.8566.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'd say add an extra horizontal split in the second column, so you'd get 
> three areas in the right column:
> - top for the global target (permanently)
> - middle for current, either:
>   - "current most lagging" if "Global" is selected in left column
>   - selected process if a specific target is selected in left column
> - bottom for backtrace
> 
> Maybe with that setup "Global" in the left column should be renamed to 
> something like "Dynamic".
> 
> The backtrace area would show selection from either top or middle areas 
> (so selecting a cause in top or middle area should unselect causes in the 
> other).

I'll have a look after the merge window madness. Multiple windows is
also still an option I suppose even if i don't like it that much: we
could support double-click on an app or "global" in the left list,
making that pop a new window with the same content as the right pane for
that app (or global) that updates at the same time as the rest.

Somebody ping me if I seem to have forgotten about it in 2 weeks :-)

Ben.



