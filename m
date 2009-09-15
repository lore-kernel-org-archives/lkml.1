Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbZIOWCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbZIOWCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZIOWCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:02:39 -0400
Received: from dan.rpsys.net ([93.97.175.187]:52948 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZIOWCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:02:38 -0400
Subject: Re: [RFC][PATCH] LED driver for Intel NAS SS4200 series
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1253051528.10449.11884.camel@nimitz>
References: <1253047135.10449.11657.camel@nimitz>
	 <1253050704.30165.64.camel@dax.rpnet.com>
	 <1253051528.10449.11884.camel@nimitz>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 22:59:04 +0100
Message-Id: <1253051944.30165.68.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 14:52 -0700, Dave Hansen wrote:
> On Tue, 2009-09-15 at 22:38 +0100, Richard Purdie wrote:
> > At a quick review this looks good. One question: These LEDs appear to be
> > attached to generic GPIOs on a southbridge that is probably in other
> > devices? If so, how do we know they're connected to LEDs? Do we need to
> > add some further check of what kind of device we're running on?
> 
> Good question.  I assumed that the PCI ids were a sufficient enough
> check.  But, you're right, those PCI ids look like they're for all ICH7
> boards.
> 
> Any suggestions on what kinds of checks we might add?  This thing acts
> like a pretty generic normal PC.  Do any of the other LED drivers have a
> similar problem?

Yes. In this case can we check for a set of DMI IDs? The clevo mail
driver has an example of that...

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

