Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYDMXKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYDMXKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYDMXKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:10:45 -0400
Received: from mail.crca.org.au ([67.207.131.56]:51983 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYDMXKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:10:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Nigel Cunningham <ncunningham@crca.org.au>
To: benh@kernel.crashing.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1208126822.6958.63.camel@pasglop>
References: <200804040111.15255.rjw@sisk.pl>
	 <200804132339.45280.rjw@sisk.pl> <1208124646.6958.61.camel@pasglop>
	 <200804140027.12161.rjw@sisk.pl>  <1208126822.6958.63.camel@pasglop>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 14 Apr 2008 09:11:29 +1000
Message-Id: <1208128289.29577.25.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael etc.

On Mon, 2008-04-14 at 08:47 +1000, Benjamin Herrenschmidt wrote:
> > Well, I'm not sure and I'm not going to introduce the change right now, after
> > the paches have been included in -mm.
> > 
> > That would require quite some changes in the core code that I'd prefer to
> > avoid for now.  We can do something like this in a separate patch series after
> > the present one settles down a bit.
> 
> I disagree.
> 
> Doing it later would introduce yet another major semantic change.
> 
> I think we should get it right now. There's no hurry in pushing things
> especially if they aren't quite right.
> 
> The ability for prepare() callbacks to sync with userland,
> request_firmware, etc... is an important feature that's been needed for
> some time imho.
> 
> Ben.

I agree. These calls have already been changing far too often in
mainline. I know it's all been necessary but please, can we try to make
one set of changes and just get it right this time?

Regards,

Nigel

