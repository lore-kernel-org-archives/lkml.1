Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZBKBTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZBKBTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZBKBSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:18:54 -0500
Received: from mx1.suse.de ([195.135.220.2]:48371 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbZBKBSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:18:53 -0500
Date: Wed, 11 Feb 2009 02:18:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
In-Reply-To: <20090210171358.78c34d41@infradead.org>
Message-ID: <alpine.LNX.1.10.0902110216190.11630@jikos.suse.cz>
References: <20090204191540.2d6abd87@infradead.org> <20090210202558.GH1382@ucw.cz> <200902102300.19065.rjw@sisk.pl> <alpine.LRH.1.10.0902110156390.22097@twin.jikos.cz> <20090210171358.78c34d41@infradead.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009, Arjan van de Ven wrote:

> > > From what I have heard there are different models of MSI Wind out 
> > > there, with different set of hardware configurations.
> > Arjan, Rafael, could you please provide the dmidecode outputs for the 
> > working and non-working systems, so that we can see what are the 
> > differences?
> does this matter for the patch ?

Only in a very minor way -- if the board name in the DMI is the same, we 
could avoid performing the extra resets when not needed by specifying a 
different DMI match criteria.

-- 
Jiri Kosina
SUSE Labs
