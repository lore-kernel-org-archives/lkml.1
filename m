Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYA2Xhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYA2Xhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYA2XhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:37:22 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40384 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYA2XhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:37:21 -0500
Date: Wed, 30 Jan 2008 00:37:20 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jon Masters <jonathan@jonmasters.org>
cc: Michael Tokarev <mjt@tls.msk.ru>, Frederik Himpe <fhimpe@telenet.be>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Udev coldplugging loads 8139too driver instead of 8139cp
In-Reply-To: <1201649657.2271.81.camel@perihelion>
Message-ID: <Pine.LNX.4.64.0801300036390.14907@fbirervta.pbzchgretzou.qr>
References: <1201554992.13883.13.camel@Anastacia>  <479E7750.9060304@msgid.tls.msk.ru>
 <1201649657.2271.81.camel@perihelion>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2008 18:34, Jon Masters wrote:
>On Tue, 2008-01-29 at 03:46 +0300, Michael Tokarev wrote:
>
>> Udev in fact loads both - 8139cp and 8139too.  The difference is the ORDER
>> in which it loads them - if for "cp-handled" hardware it first loads "too",
>> too will complain as above and will NOT claim the device.  The same is
>> true for the opposite.
>[...]
>> In short: NotABug, or ComplainToRealtec (but that's waaaay too late and
>> will not help anyway) ;)
>
>Nah. It's a "bug" insomuch as we don't handle multiple matching aliases
>very well, and it's becoming more common, so we probably should :)

Why not combine 8139cp.c and 8139too.c?
