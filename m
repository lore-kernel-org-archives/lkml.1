Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbYBUBX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbYBUBX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYBUBXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:23:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33550 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbYBUBXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:23:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [BUG?] APM is hidden in menuconfig
Date: Thu, 21 Feb 2008 02:21:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: jarkao2@gmail.com, linux-kernel@vger.kernel.org
References: <20080220120828.GD3885@ff.dom.local> <200802210123.44367.rjw@sisk.pl> <E1JS02I-0003gO-Py@faramir.fjphome.nl>
In-Reply-To: <E1JS02I-0003gO-Py@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210221.52765.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Frans Pop wrote:
> Rafael J. Wysocki wrote:
> > On Wednesday, 20 of February 2008, Jarek Poplawski wrote:
> >> So, has it to be so hard? It seems not - at least in good old times...
> > 
> > Something in APM uses some code from drivers/base/power/main.c that
> > depends on PM_SLEEP.
> 
> Sure, but that does not make Jarek's point invalid. From a user PoV APM is a
> high-level configuration option. That is what he wants.
> It should thus be easily accessible and not be buried beneath a lot of
> other, much more technical, options.
> 
> Could this maybe be solved by making APM automatically 'select' some options
> instead of 'depending' on them?

That, unfortunately, doesn't work.

IMO the solution might be to separate the APM suspend code from the rest of the
APM code and make it depend on (PM_SUSPEND && APM).

Thanks,
Rafael
