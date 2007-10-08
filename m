Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXJHOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXJHOdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXJHOdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:33:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbXJHOdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:33:06 -0400
Date: Mon, 8 Oct 2007 10:32:52 -0400
From: Rik van Riel <riel@redhat.com>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 regression: do_nanosleep will not return
Message-ID: <20071008103252.5fe81529@bree.surriel.com>
In-Reply-To: <fedaqr$njj$1@sea.gmane.org>
References: <fed93g$eq4$1@sea.gmane.org>
	<fedaqr$njj$1@sea.gmane.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2007 15:20:26 +0200
Bernd Schubert <bs@q-leap.de> wrote:
> Bernd Schubert wrote:

> > we have a system here were e.g. "sleep 1" will never finish. This
> > is an issue of 2.6.23, on all older kernel versions it did work
> > fine.
> > 
> > Seems to hang in do_nanosleep()
> 
> 
> Update: Enabling hpet in the bios and setting clocksource=hpet as
> command line parameter will fix it, but still its not nice that
> something that worked without a problem in 2.6.22 and below suddenly
> doesn't work in 2.6.23.

Which timer source is in use when the system hangs?

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
