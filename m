Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZIILz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZIILz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZIILzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:55:55 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:55442 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbZIILzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:55:55 -0400
From: Frans Pop <elendil@planet.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Wed, 9 Sep 2009 13:55:54 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, realnc@arcor.de,
       linux-kernel@vger.kernel.org
References: <20090906205952.GA6516@elte.hu> <200909082222.44828.elendil@planet.nl> <1252489988.26522.46.camel@pasglop>
In-Reply-To: <1252489988.26522.46.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909091355.56335.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2009 11:55:56.0828 (UTC) FILETIME=[7D9A45C0:01CA3144]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009, Benjamin Herrenschmidt wrote:
> On Tue, 2009-09-08 at 22:22 +0200, Frans Pop wrote:
> > Arjan van de Ven wrote:
> > > the latest version of latencytop also has a GUI (thanks to Ben)
> >
> > That looks nice, but...
> >
> > I kind of miss the split screen feature where latencytop would show
> > both the overall figures + the ones for the currently most affected
> > task. Downside of that last was that I never managed to keep the
> > display on a specific task.
>
> Any idea of how to present it ? I'm happy to spend 5mn improving the
> GUI :-)

I'd say add an extra horizontal split in the second column, so you'd get 
three areas in the right column:
- top for the global target (permanently)
- middle for current, either:
  - "current most lagging" if "Global" is selected in left column
  - selected process if a specific target is selected in left column
- bottom for backtrace

Maybe with that setup "Global" in the left column should be renamed to 
something like "Dynamic".

The backtrace area would show selection from either top or middle areas 
(so selecting a cause in top or middle area should unselect causes in the 
other).

Cheers,
FJP
