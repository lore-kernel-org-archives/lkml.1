Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZFWVGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZFWVGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZFWVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:06:09 -0400
Received: from kroah.org ([198.145.64.141]:42455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbZFWVGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:06:08 -0400
Date: Tue, 23 Jun 2009 13:57:00 -0700
From: Greg KH <greg@kroah.com>
To: Olivier Galibert <galibert@pobox.com>, Frans Pop <elendil@planet.nl>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090623205700.GA6385@kroah.com>
References: <20090623135529.GA2668@elf.ucw.cz> <200906231709.45851.elendil@planet.nl> <20090623161334.GA503@kroah.com> <20090623203518.GA8388@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623203518.GA8388@dspnet.fr.eu.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 10:35:18PM +0200, Olivier Galibert wrote:
> On Tue, Jun 23, 2009 at 09:13:34AM -0700, Greg KH wrote:
> > If for some reason you can not use the /dev/bus/usb/ device nodes, you
> > can enable the config option by turning on CONFIG_EMBEDDED.
> 
> Wasn't CONFIG_EMBEDDED defined as an option to enable _removing_
> useful stuff normal people do not want to remove?  I for one would
> never imagine going there to put back legacy stuff.

It works the same way, we really want this option to be disabled, as it
is not needed on "modern" systems.  But if you want it back, like on
some embedded systems that have only local root users, then
CONFIG_EMBEDDED will allow you to do that.

thanks,

greg k-h
