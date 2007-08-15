Return-Path: <linux-kernel-owner+w=401wt.eu-S935794AbXHOStt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935794AbXHOStt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbXHOStg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:49:36 -0400
Received: from belushi.uits.indiana.edu ([129.79.1.188]:47177 "EHLO
	belushi.uits.indiana.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574AbXHOStf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:49:35 -0400
X-Greylist: delayed 1580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 14:49:34 EDT
Subject: Re: Thinking outside the box on file systems
From: Brian Wheeler <bdwheele@indiana.edu>
To: mperkel@yahoo.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 15 Aug 2007 14:23:12 -0400
Message-Id: <1187202192.30730.25.camel@wombat.dlib.indiana.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HI

While I find your ideas intriguing, I'd like to offer a friendly
suggestion:  You're never going to convince anyone on LKML unless you do
the following things:
	* Describe your idea in detail, including algorithms, pseudo code,
pictures, or whatever.  Vague hand-wavey stuff won't do it.
	* Don't accuse others of being close minded (i.e. "not thinking outside
the box").  Explain why their assertions may not be correct according to
your proposal.
	* Accept that others have far more experience, no matter how
experienced you are.
	* Remember that the current assumptions can't just break when the idea
is implemented:  backwards compatibility is important.

Also, be prepared to have your idea shot down.  Very few ideas make it
into the kernel, and those only get there after months of hashing out
the details.

Brian

--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 15, 2007, at 13:19:16, Marc Perkel wrote:
> > One of the problems with the Unix/Linux world is
> that your minds  
> > are locked into this one model. In order to do it
> right it requires  
> > the mental discipline to break out of that.
> 
> The major thing that you are missing is that this
> "one model" has  
> been very heavily tested over the years.  People
> understand it, know  
> how to use it and write software for it, and grok
> its limitations.   
> There's also a vast amount of *existing* code that
> you can't just  
> "deprecate" overnight; the world just doesn't work
> that way.  The  
> real way to get there (IE: a new model) from here
> (IE: the old model)  
> is the way all Linux development is done with a lot
> of sensible easy- 
> to-understand changes and refactorings.
> 
> With that said, if you actually want to sit down and
> start writing  
> *code* for your model, go ahead.  If it turns out to
> be better than  
> our existing model then I owe you a bottle of your
> favorite beverage.
> 
> Cheers,
> Kyle Moffett
> 


When one thinks outside the box one has to think about
evolving beyond what you are used to. When I moved
beyond DOS I have to give up the idea of 8.3 file
names. The idea here is to come up with a model that
can emulate the existing system for backwards
compatibility.

The concept behind my model is to create a new layer
where you can do ANYTHING with file names and
permissions and create models that emulate Linux, DOS,
Windows, Mac, or anything else you can dream of. Then
you can create a Linux/Windows/Mac template to emulate
what you are used to.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com

