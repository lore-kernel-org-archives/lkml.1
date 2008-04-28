Return-Path: <linux-kernel-owner+w=401wt.eu-S937534AbYD1TF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937534AbYD1TF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933808AbYD1TFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:05:46 -0400
Received: from ic0245.upco.es ([130.206.70.245]:42954 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765485AbYD1TFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:05:44 -0400
Subject: Re: If you want me to quit I will quit
From: Romano Giannetti <romanol@upcomillas.es>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Bunk <bunk@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804261333200.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick>
	 <20080426110044.GB2252@cs181133002.pp.htv.fi>
	 <20080426075132.b0fdbe13.akpm@linux-foundation.org>
	 <20080426152341.GI2252@cs181133002.pp.htv.fi>
	 <20080426084420.8e61c379.akpm@linux-foundation.org>
	 <20080426171604.GN2252@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
	 <481379BB.5050208@s5r6.in-berlin.de>
	 <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org>
	 <20080426133049.187e255c.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0804261333200.2813@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 28 Apr 2008 21:05:14 +0200
Message-Id: <1209409514.25791.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-26 at 13:35 -0700, Linus Torvalds wrote:

> > Fact is, this is the way in which developers want to work.  That is their
> > workflow, and their tools should follow their workflow.  If a tool's
> > behaviour prevents them from implementing their desired workflow, it isn't
> > the workflow which should be changed ;)
> 
> But that was exactly my point. Bugs *will* happen. Follow-up patches 
> *will* happen. Don't fight it. Do the best you can do - there's no way 
> people will ever avoid all bugs to begin with. 

Sorry if I drop in into a thread that's probably too big for me, but I
was having an idea (probably horribly wrong, but I try... don't beat too
hard). I think the main problem is when a fix to a change occurs quite
after the change went in, creating bisection problems (I've had
something like that bisecting an MMC problems some time ago). 

Wouldn't be nice to have the concept of patch series in git? Maybe the
sha1 of the first commit of the patch? Then a fix on the series can be
marked  as such, and you could teach git bisect to go first series by
series, applying/removing the fix patches as needed... and just at the
end dive into the commits. Maybe it's impossible/too complex/exponntial,
but well, it just a git git idea :-)

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
