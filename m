Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXCGN5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXCGN5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965494AbXCGN5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:57:24 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:55425 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbXCGN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:57:23 -0500
To: a.p.zijlstra@chello.nl
CC: npiggin@suse.de, miklos@szeredi.hu, akpm@linux-foundation.org,
       mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, jdike@addtoit.com
In-reply-to: <1173275532.6374.183.camel@twins> (message from Peter Zijlstra on
	Wed, 07 Mar 2007 14:52:12 +0100)
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes
	nonlinear)
References: <20070307102106.GB5555@wotan.suse.de>
	 <1173263085.6374.132.camel@twins> <20070307103842.GD5555@wotan.suse.de>
	 <1173264462.6374.140.camel@twins> <20070307110035.GE5555@wotan.suse.de>
	 <1173268086.6374.157.camel@twins> <20070307121730.GC18704@wotan.suse.de>
	 <1173271286.6374.166.camel@twins> <20070307130851.GE18704@wotan.suse.de>
	 <1173273562.6374.175.camel@twins>  <20070307133649.GF18704@wotan.suse.de> <1173275532.6374.183.camel@twins>
Message-Id: <E1HOwdH-0000UY-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Mar 2007 14:56:43 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well I don't think UML uses nonlinear yet anyway, does it? Can they
> > make do with restricting nonlinear to mlocked vmas, I wonder? Probably
> > not.
> 
> I think it does, but lets ask, Jeff?

Looks like it doesn't:

$ grep -r remap_file_pages arch/um/
$

Miklos
