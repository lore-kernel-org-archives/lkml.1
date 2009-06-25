Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZFYRSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZFYRSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZFYRSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:18:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33788 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZFYRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:18:30 -0400
Date: Fri, 26 Jun 2009 02:17:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>, paul@pwsan.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] Driver Core: Add platform device arch data V3
Message-ID: <20090625171728.GA25320@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Magnus Damm <magnus.damm@gmail.com>, paul@pwsan.com, gregkh@suse.de,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se> <200906242050.57312.rjw@sisk.pl> <aec7e5c30906241925n3eeaee65of0dcf0286f60366d@mail.gmail.com> <200906251634.12222.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906251634.12222.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 04:34:11PM +0200, Rafael J. Wysocki wrote:
> On Thursday 25 June 2009, Magnus Damm wrote:
> > If possible, I'd like this to be merged as early as possible since a
> > lot of processor specific changes will depend on it. With this
> > included in 2.6.31 I can easily build arch specific code for 2.6.32.
> > Anything I can do to make that happen?
> > 
> > My top priority is Runtime PM for SuperH on top of your code, and I
> > intend to post a prototype for SuperH before the PM Summit. It would
> > be great to minimize the dependencies though, and including this in
> > 2.6.31 would certainly help.
> 
> I'm going to add this patch to my linux-next branch shortly and if your 2.6.32
> development is based on that branch (I'd recommend that anyway), there
> shouldn't be any problems during the 2.6.32 merge window.
> 
Yes, I was already planning on creating a topic branch based off of this
so that we can start getting things ready in the sh tree, so this is not
a problem.. as long as you don't rebase ;-)
