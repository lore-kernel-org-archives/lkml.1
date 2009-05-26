Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZEZV1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZEZV1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZEZV1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:27:33 -0400
Received: from mail.crca.org.au ([67.207.131.56]:54574 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbZEZV1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:27:32 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090526091940.GA29867@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905252343.23744.rjw@sisk.pl> <200905260045.33902.oliver@neukum.org>
	 <200905260058.54482.rjw@sisk.pl>  <20090526091940.GA29867@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 27 May 2009 07:29:20 +1000
Message-Id: <1243373360.13930.57.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2009-05-26 at 11:19 +0200, Pavel Machek wrote:
> Hi!
> 
> > > If you really have drivers that have exceptionally large memory requirements
> > > (eg. you need to copy video ram), you should tell the system through struct
> > > driver and do accounting at probe and removal of devices.
> > 
> > Or perhaps the drivers should allocate memory from a PM notifier (which is
> > called before the freezing of tasks) to avoid the problem?
> 
> Yes, that's how it should work for big allocations.
> 
> For small allocations... I still believe we should free a bit of
> memory for s2ram so that small allocations can be done without
> problems.

Big vs small shouldn't matter. One simple, clear method of doing things.
Otherwise we won't get the predictability we're seeking.

Nigel

