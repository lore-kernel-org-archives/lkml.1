Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZLROXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZLROXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZLROXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:23:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:57683 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZLROXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:23:44 -0500
Date: Fri, 18 Dec 2009 15:23:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: Ali Gholami Rudi <ali@rudi.ir>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] trivial: fix checking socket() in net tstamp example
In-Reply-To: <1257701045.29123.288.camel@pohly-mobl1.ikn.intel.com>
Message-ID: <alpine.LNX.2.00.0912181523200.3755@pobox.suse.cz>
References: <20091108155923.GA820@lilem.mirepesht> <1257701045.29123.288.camel@pohly-mobl1.ikn.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009, Patrick Ohly wrote:

> > diff --git a/Documentation/networking/timestamping/timestamping.c b/Documentation/networking/timestamping/timestamping.c
> > index a7936fe..bab619a 100644
> > --- a/Documentation/networking/timestamping/timestamping.c
> > +++ b/Documentation/networking/timestamping/timestamping.c
> > @@ -370,7 +370,7 @@ int main(int argc, char **argv)
> >  	}
> >  
> >  	sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
> > -	if (socket < 0)
> > +	if (sock < 0)
> 
> Argh, of course you are right. FWIW, acknowledged.

Doesn't seem to be present in 2.6.33-rc1, I have applied it to my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
