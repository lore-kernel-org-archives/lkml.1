Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYLOXD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYLOXD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYLOXDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:03:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbYLOXDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:03:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Tue, 16 Dec 2008 00:02:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <gi247o$iog$1@ger.gmane.org> <200812152119.35228.rjw@sisk.pl> <gi6g21$bnf$8@ger.gmane.org>
In-Reply-To: <gi6g21$bnf$8@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812160002.43427.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 15 of December 2008, Brian J. Murrell wrote:
> On Mon, 15 Dec 2008 21:19:34 +0100, Rafael J. Wysocki wrote:
> > Does it also happen in the minimal configuration (ie. with
> > init=/bin/bash)?
> 
> Now, that's an interesting result.  Using the above, pm-suspend does 
> suspend fine and hitting the flashing power button will resume fine with 
> the exception of the screen is still black.  That is backlight problems 
> isn't it?  I can see by disk light activity though that it's actually 
> still alive though.

No, most probably your graphics adapter is not handled correctly in this case,
because it needs some special user space quirks, which are done by hald that is
not running.

You can try to use the s2ram binary (http://en.opensuse.org/s2ram) to work
around this issue.

Anyway, if you suspend for the second time from this state, does it resume?

Rafael
