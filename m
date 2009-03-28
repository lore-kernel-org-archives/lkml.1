Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbZC1AU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbZC1AU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZC1AUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:20:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46548 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753838AbZC1AUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:20:46 -0400
Date: Sat, 28 Mar 2009 00:21:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: netrom: zero length frame filtering in NetRom
Message-ID: <20090328002137.52558018@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327.143406.192730131.davem@davemloft.net>
References: <200903270102.n2R12S2U021576@hera.kernel.org>
	<20090327102823.3c485bfc@lxorguk.ukuu.org.uk>
	<20090327.143406.192730131.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 14:34:06 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 27 Mar 2009 10:28:23 +0000
> 
> > 
> > > +	/* NetRom empty data frame has no meaning : ignore it */
> > > +	if (copied == 0) {
> > > +		goto out;
> > > +	}
> > > +
> > 
> > Also broken - and doesn't follow the coding style either 8)
> 
> Well, you send these turds to me and you're usually knowledgable
> in the amateur radio protocol area :-)
> 
> I'll back them both out which is what I assume you want me to
> do.

Yes. Handling zero length frames with socket API is nasty and ugly but
unfortunately its a valid use of these protocols. I need to go read the
AF_ROSE docs to double check the situation with ROSE but the other two
definitely want backing out.

Alan
