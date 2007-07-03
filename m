Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbXGCIU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbXGCIU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbXGCIUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:20:17 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35254 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXGCIUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:20:16 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 10:20:13 +0200
User-Agent: KMail/1.9.7
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <1183448224.12649.14.camel@localhost>
In-Reply-To: <1183448224.12649.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707031020.13691.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Romano Giannetti:
> On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> > or alternatively we  could do what we do for suspend to RAM on other
> > platforms (PPC and APM) and just not use the freezer.
> 
> As a data point, I am running with this patch on top of 2.6.21.2 the
> last 3+ weeks, with an average of 5/6 STR cycles a day, and had no
> problems at all. (Sony vaio pcg-fx701). Just normal work, I didn't try
> to stress the thing, but I have quite a few times suspended/resumed over
> a big compile without a glitch.
> 
> What are the risks of this patch supposed to be?

You did this test only while stressing normal block devices. Try
provoking races in character devices.

	Regards
		Oliver

