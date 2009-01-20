Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbZATBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbZATBSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760230AbZATBSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:18:21 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44353 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759848AbZATBST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:18:19 -0500
X-Sasl-enc: ftBWXYaueUJIVUV0T+bn1vIpkOGyAGx80155IGPh2NPQ 1232414297
Subject: Re: [PATCH] autofs: fix the wrong usage of
	the	deprecated	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
In-Reply-To: <4974B3B7.5060608@zytor.com>
References: <20090118073441.GA699@redhat.com>
	 <1232331602.3136.19.camel@zeus.themaw.net>  <49741F14.80808@zytor.com>
	 <1232351101.3136.87.camel@zeus.themaw.net>  <4974B3B7.5060608@zytor.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 10:18:19 +0900
Message-Id: <1232414299.3136.2.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 09:09 -0800, H. Peter Anvin wrote:
> Ian Kent wrote:
> >>>
> >> The other thing is also: isn't it high time to remove autofs 3?  It has
> >> been unmaintained for at least 10 years now.  I should know ;)
> > 
> > That's a good idea.
> > Couldn't we rename autofs4 to autofs and add a MODULE_ALIAS("autofs4")
> > or something?
> > 
> 
> Works for me.  Now, this really isn't an -rc2 kind of thing, but I would
> ACK such a change for the next merge window.

Sounds good to me.
I'll try for the next merge window.

Ian

