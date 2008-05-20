Return-Path: <linux-kernel-owner+w=401wt.eu-S934047AbYETPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbYETPyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYETPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:54:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49631 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756750AbYETPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:54:07 -0400
Message-Id: <1211298846.8328.1254165905@webmail.messagingengine.com>
X-Sasl-Enc: vMkD4itlAS1Gc8sQQpTMHopHbUOTKk8RzyXd7TItshXy 1211298846
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Thomas Renninger" <trenn@suse.de>,
       "Dmitry Torokhov" <dtor@mail.ru>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
   <1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
   <200805201209.08986.IvDoorn@gmail.com>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input
   subsystem interactions
In-Reply-To: <200805201209.08986.IvDoorn@gmail.com>
Date: Tue, 20 May 2008 12:54:06 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008 12:09:08 +0200, "Ivo van Doorn" <ivdoorn@gmail.com> said:
> > +You should:
> >  	- rfkill_allocate()
> > -	- input_allocate_polled_device()
> > +	- modify rfkill fields (flags, name)
> > +	- modify state to the current hardware state (THIS IS THE ONLY TIME
> > +	  YOU CAN ACCESS state DIRECTLY)
> >  	- rfkill_register()
> > -	- input_register_polled_device()
> 
> Wasn't it the plan to send the current hardware state as rfkill
> registration argument,
> so we can force drivers to send a valid state to rfkill?

Yes, but IMHO we should do that in a future patch.  That patch will touch
every rfkill driver, so I'd rather we do that later.  IMHO it is best to get
the most important stuff merged, first...

Then, in that future patch, we change the API, fix all in-tree drivers using
that API, and update the documentation to match the new API.  For now, we
update the documentation to match the current API.

What do you think?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

