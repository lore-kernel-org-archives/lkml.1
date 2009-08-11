Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZHKVAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZHKVAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZHKVAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:00:11 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:47978 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZHKVAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:00:10 -0400
Date: Tue, 11 Aug 2009 23:59:57 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
 userspace-consumer)
Message-ID: <20090811205957.GD13969@gandalf>
Reply-To: me@felipebalbi.com
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811204914.GB13969@gandalf>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 11, 2009 at 11:49:18PM +0300, Felipe Balbi wrote:
> Sure. Another point to be taken into account is how often to check
> battery status; I mean, if the system is idle, we don't need to check
> battery every second since battery temperature and juice won't change
> that quickly anyways, but when doing some hardcore stuff on the CPU then
> we need to check such variables more often.

oops, SBS Data spec already gives good information about that.
Normally check the battery once every 10 secs.

Refer to SBS Data Spec Item 4.4.5

-- 
balbi
