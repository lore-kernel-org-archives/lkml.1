Return-Path: <linux-kernel-owner+w=401wt.eu-S1764160AbXJSLZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764160AbXJSLZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbXJSLZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:25:34 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:62261 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbXJSLZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:25:32 -0400
Subject: Re: 2.6.23-mm1 s390 driver problem
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com,
       heiko.carstens@de.ibm.com, sam@ravnborg.org,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
In-Reply-To: <47189242.8090006@fr.ibm.com>
References: <20071018200148.GA14234@vino.hallyn.com>
	 <200710182215.56428.borntraeger@de.ibm.com>
	 <20071018203151.GA15382@vino.hallyn.com>
	 <1192780036.25150.7.camel@localhost> <471875E0.8040308@fr.ibm.com>
	 <20071019022719.537ee71f.akpm@linux-foundation.org>
	 <47189242.8090006@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Fri, 19 Oct 2007 13:25:29 +0200
Message-Id: <1192793129.25150.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 13:17 +0200, Cedric Le Goater wrote:
> > please cc netdev on network issues.
> 
> yes.
> 
> >> Bringing up interface eth0:  ------------Ý cut here ¨------------ 
> >> Kernel BUG at 0000000000000002 Ýverbose debug info unavailable¨ 
> >> illegal operation: 0001 Ý#1¨ 
> > 
> > that's a network issue ;)
> > 
> >> 00000000002b3352 gives : include/linux/netdevice.h:819
> >>
> > 
> > I have a feeling that we fixed this.  But there's no BUG at 2.6.23-mm1's
> > include/linux/netdevice.h:819.  
> 
> but dev->header_ops is bogus. right ?
> 
> > How about setting CONFIG_DEBUG_BUGVERBOSE=y?
> 
> it is set :(

This is definitly a problem with the header_ops in the qeth network
driver. I've asked our network team to take care of it. Stay tuned..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


