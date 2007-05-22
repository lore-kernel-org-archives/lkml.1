Return-Path: <linux-kernel-owner+w=401wt.eu-S1765770AbXEVNje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765770AbXEVNje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 09:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbXEVNj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 09:39:27 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:12013 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbXEVNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 09:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XR1C6/JoXENdDCiP7DrypFVx1+NgQUWKMdO8lkrIT8GdTe+9BYN/dGEleRDvtWlFl4CJGt+u0Icy/0bQnKOdH8AFguHWKb/wX/ccXlUg2eziBe221cT956Qc1JhK6khIQcDmPd+8B/jZA87O9zELLI8uET19DK8ZRpMZ0GeqISc=
Message-ID: <7b69d1470705220639w767eda81g5d4988ef09d77316@mail.gmail.com>
Date: Tue, 22 May 2007 08:39:25 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: [PATCH] Documentation/memory-barriers.txt: various fixes
Cc: "David Howells" <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@mindspring.com>
In-Reply-To: <20070521151953.GC4050@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070521135048.GB4050@ff.dom.local>
	 <20070521094224.GB1695@ff.dom.local> <7846.1179749390@redhat.com>
	 <12203.1179756727@redhat.com> <20070521151953.GC4050@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jarek Poplawski <jarkao2@o2.pl> wrote:
> On Mon, May 21, 2007 at 03:12:07PM +0100, David Howells wrote:
> > Jarek Poplawski <jarkao2@o2.pl> wrote:
> >
> > > > > -     load will be directed), a data dependency barrier would be required to
> > > > > +     load will be directed), the data dependency barrier would be required to
> > > >
> > > > I think that should be "a".
> > >
> > > I could only guess (it's a magic to me) - so, if it doesn't matter
> > > "A data ..." begins this paragraph...
> >
> > I see what you mean.  I see it as "a data dependency barrier ..." though.  That
> > may be because I wrote the doc, however.  I wonder if "data dependency" should
> > be hyphenated to make it clearer.  What do you think?
>
> Better don't ask. Now I'm far less decided, than yesterday.
---

"data-dependency barrier" would be better, assuming you mean a barrier
enforcing a data dependency. If you say "data dependency barrier" you
could also mean a "dependency barrier" implemented as a piece of data,
for instance, like a flag value in a data stream that forces
synchronization with another data stream.

scott
