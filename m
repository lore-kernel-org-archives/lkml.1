Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZC0WOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZC0WOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZC0WOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:14:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42071
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbZC0WOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:14:15 -0400
Date: Fri, 27 Mar 2009 15:14:03 -0700 (PDT)
Message-Id: <20090327.151403.69546283.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: netrom: zero length frame filtering in NetRom
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090327.143406.192730131.davem@davemloft.net>
References: <200903270102.n2R12S2U021576@hera.kernel.org>
	<20090327102823.3c485bfc@lxorguk.ukuu.org.uk>
	<20090327.143406.192730131.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 27 Mar 2009 14:34:06 -0700 (PDT)

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

Sorry Alan, I thought you were replying to the patches you
sent yesterday, my bad.
