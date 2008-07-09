Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYGIWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYGIWGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYGIWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:06:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55683 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYGIWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:06:05 -0400
Date: Wed, 9 Jul 2008 15:05:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.26-rc8-mm1 - Missing AC97 power save Kconfig?
Message-Id: <20080709150512.3b3bfdcf.randy.dunlap@oracle.com>
In-Reply-To: <48752EB2.8050406@acm.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<48752EB2.8050406@acm.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 15:33:38 -0600 Zan Lynx wrote:

> Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/
> > 
> > - Seems to work on my x86 test boxes.  It does emit a
> >   sleeping-while-atomic warning during exit from an application which
> >   holds mlocks.  Known problem.
> > 
> > - It's dead as a doornail on the powerpc Mac g5.  I'll bisect it later.
> [cut]
> 
> I don't know if this is well known, or why no one else noticed if it
> isn't, but the AC97 power-save Kconfig option CONFIG_SND_AC97_POWER_SAVE
> isn't in any of the Kconfig files.

Did you search for just /SND_AC97_POWER_SAVE/ ?  (no CONFIG_)

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
