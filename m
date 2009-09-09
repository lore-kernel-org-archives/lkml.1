Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZIILdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZIILdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZIILdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:33:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:47364 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZIILdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:33:17 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Newall <davidn@davidnewall.com>
Cc: Frans Pop <elendil@planet.nl>, Arjan van de Ven <arjan@infradead.org>,
       realnc@arcor.de, linux-kernel@vger.kernel.org
In-Reply-To: <4AA78E15.9090206@davidnewall.com>
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org>
	 <20090907074039.1b6bc1ac@infradead.org> <4AA6056A.4020106@arcor.de>
	 <4AA6056A.4020106@arcor.de> <20090908013133.59203403@infradead.org>
	 <200909082222.44828.elendil@planet.nl> <1252489988.26522.46.camel@pasglop>
	 <4AA78E15.9090206@davidnewall.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 21:32:58 +1000
Message-Id: <1252495978.26522.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 20:44 +0930, David Newall wrote:
> Benjamin Herrenschmidt wrote:
> > On Tue, 2009-09-08 at 22:22 +0200, Frans Pop wrote:
> >   
> >> Arjan van de Ven wrote:
> >>     
> >>> the latest version of latencytop also has a GUI (thanks to Ben)
> >>>       
> >> That looks nice, but...
> >>
> >> I kind of miss the split screen feature where latencytop would show both 
> >> the overall figures + the ones for the currently most affected task. 
> >> Downside of that last was that I never managed to keep the display on a 
> >> specific task.
> >>     
> >
> > Any idea of how to present it ? I'm happy to spend 5mn improving the
> > GUI :-) 
> 
> Use a second window.

I'm not too fan of cluttering the screen with windows... I suppose I
could have a separate pane for the "global" view but I haven't found a
way to lay it out in a way that doesn't suck :-) I could have done a 3rd
colums on the right with the overall view but it felt like using too
much screen real estate.

I'll experiment a bit, maybe 2 windows is indeed the solution. But you
get into the problem of what to do if only one of them is closed ? Do I
add a menu bar on each of them to re-open the "other" one if closed ?
etc...

Don't get me wrong, I have a shitload of experience doing GUIs (back in
the old days when I was hacking on MacOS), though I'm relatively new to
GTK. But GUI design is rather hard in general :-)

Ben.


