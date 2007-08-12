Return-Path: <linux-kernel-owner+w=401wt.eu-S935517AbXHLWIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517AbXHLWIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761607AbXHLWIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:08:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59469 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760038AbXHLWIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:08:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: When to use a freezeable workqueue?
Date: Mon, 13 Aug 2007 00:18:38 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <46BEC0AD.7080202@s5r6.in-berlin.de>
In-Reply-To: <46BEC0AD.7080202@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130018.38652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 12 August 2007 10:11, Stefan Richter wrote:
> In which situations is create_freezeable_workqueue() to be preferred
> over create_singlethread_workqueue()?
> 
> Is a freezable worqueue preferable whenever the worker thread /can/ be
> frozen, or is it only to be used if the thread /must/ be frozen during
> suspend?

The latter, IMO.

Generally, if you want it to be frozen.

Greetings,
Rafael
