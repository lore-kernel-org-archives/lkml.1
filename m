Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZC0Ve1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZC0Ve1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZC0VeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:34:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43546
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbZC0VeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:34:19 -0400
Date: Fri, 27 Mar 2009 14:34:06 -0700 (PDT)
Message-Id: <20090327.143406.192730131.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: netrom: zero length frame filtering in NetRom
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090327102823.3c485bfc@lxorguk.ukuu.org.uk>
References: <200903270102.n2R12S2U021576@hera.kernel.org>
	<20090327102823.3c485bfc@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 27 Mar 2009 10:28:23 +0000

> 
> > +	/* NetRom empty data frame has no meaning : ignore it */
> > +	if (copied == 0) {
> > +		goto out;
> > +	}
> > +
> 
> Also broken - and doesn't follow the coding style either 8)

Well, you send these turds to me and you're usually knowledgable
in the amateur radio protocol area :-)

I'll back them both out which is what I assume you want me to
do.
