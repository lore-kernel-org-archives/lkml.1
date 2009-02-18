Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZBRSBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZBRSBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZBRSBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:01:39 -0500
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:47117 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193AbZBRSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:01:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=tNj37m1/PIpCAziSbeGUs09S2NiJQDPUjweJCI3x3OB1rGOEzvdbSZ6iSi1ZJAL9Tvip/KmfJhCYX11bql9yZpQl3AES4EfV25PCyMmJnzT390SRRPjw7ZBCKrqcWd3h;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 10:01:35 -0800
User-Agent: KMail/1.9.10
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Brian Swetland <swetland@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <200902180948.06039.jbarnes@virtuousgeek.org> <20090218175244.GA19235@srcf.ucam.org>
In-Reply-To: <20090218175244.GA19235@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181001.36927.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 18, 2009 9:52 am Matthew Garrett wrote:
> On Wed, Feb 18, 2009 at 09:48:04AM -0800, Jesse Barnes wrote:
> > I think "powernag" would be a better name, and it would probably work
> > pretty well.  Users would be notified that certain apps should probably
> > be shut down while they're on battery, and nag the authors to fix it.
>
> How do you usefully tell the difference between an application that's
> waking up a lot because it's dumb and an application that's waking up a
> lot because it's doing something useful? One downside of powertop is
> that it's resulted in a lot of "How do I reduce the number of wakeups
> caused by i8042 whenever I use the mouse"-type questions. We don't want
> innocent app writers to be hit by this kind of thing.

Well Ben did mention that it would be hard to figure out a good set of 
heuristics, but a userspace app could be pretty flexible, allowing the user 
to whitelist apps they know are fine, average the data over a period of time, 
etc.  Challenging, sure, but it should be possible to come up with something 
that's useful in many cases.

-- 
Jesse Barnes, Intel Open Source Technology Center
