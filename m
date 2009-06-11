Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZFKOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZFKOlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZFKOll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:41:41 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35913 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751230AbZFKOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:41:40 -0400
Date: Thu, 11 Jun 2009 10:41:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, npiggin@suse.de,
       yanmin.zhang@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <1244648659.23799.26.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906111040440.29827@gentwo.org>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>  <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>  <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>  <4A2BCC6F.8090004@redhat.com>  <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
  <20090608101739.GA15377@csn.ul.ie>  <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>  <20090608110303.GD15377@csn.ul.ie>  <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>  <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
  <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>  <1244534315.5024.34.camel@penberg-laptop>  <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>  <1244536124.5024.41.camel@penberg-laptop>  <4A2FC62C.6030407@lwfinger.net>
 <1244648659.23799.26.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Pekka Enberg wrote:

> Aha, SLUB thinks the minimum order for 4096 is 1. I guess you have
> CONFIG_SLUB_DEBUG enabled? If yes, something like to following should
> help. Christoph, are you okay with this patch?

He likely has CONFIG_SLUB_DEBUG_ON set which enables debugging and thus
needs more than the payload for metadata.
