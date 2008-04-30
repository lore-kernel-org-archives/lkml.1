Return-Path: <linux-kernel-owner+w=401wt.eu-S932277AbYD3TYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbYD3TYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbYD3TYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:24:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39699 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762300AbYD3TYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qGrAc3V9GzEFL13CMcPUYsGgLYWluQmJbXWQb5DL+IX+NDfx5hFOKqY6I4w1ctlofabs57JbuFv0VEHV/to8oRZWJnC2A1AWR7P+SUSDaAG/NP6BrK62V0sPLkRBn9//xTOoHAuOs1fbLFAv+JvoAQQwLcDZ4eI5M1/H0Odc4Ao=
Subject: Re: [patch, -git] isdn: hysdn_procconf.c build fix
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Denis V. Lunev" <den@openvz.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080430121452.f7735eea.akpm@linux-foundation.org>
References: <1207653508.7171.18.camel@iris.sw.ru>
	 <1207653576-12640-25-git-send-email-den@openvz.org>
	 <20080430175740.GA26612@elte.hu>
	 <20080430111052.9c0c8974.akpm@linux-foundation.org>
	 <20080430183051.GA3008@elte.hu>
	 <20080430114731.7e71f3d2.akpm@linux-foundation.org>
	 <1209582185.4310.1.camel@iris.sw.ru>
	 <20080430121452.f7735eea.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 12:24:47 -0700
Message-Id: <1209583487.24729.85.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 12:14 -0700, Andrew Morton wrote:
> On Wed, 30 Apr 2008 23:03:05 +0400
> "Denis V. Lunev" <den@openvz.org> wrote:
> > > 
> > > allmodconfig is for one thing and one thing only: compilation coverage
> > > testing.  If there is anything which is not compiled after `make
> > > allmodconfig' then that's a bug.
> > > 
> > > But how to fix it?  Perhaps we need to add a CONFIG_ALLFOOCONFIG which can
> > > be tested at the appropriate places.
> > 
> > I think that the same should be applied to allyesconfig
> 
> That's what ALLFOOCONFIG refers to ;)
> 
> There _might_ be a need to discriminate between allyesconfig and
> allmodconfig, but usually not, I expect.
> 
> Perhaps we should implement CONFIG_ALLYESCONFIG, CONFIG_ALLMODCONFIG and
> CONFIG_ALLFOOCONFIG, where
> 
> 	ALLFOOCONFIG = ALLYESCONFIG || ALLMODCONFIG
> 	
> (where FOO is renamed to something sensible, but what?)

ALLBUILDCONFIG

Harvey

