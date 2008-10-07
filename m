Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYJGWec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYJGWec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYJGWeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:34:23 -0400
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:27236 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbYJGWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:34:22 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11550] pnp: Huge number of "io resource overlap" messages
Date: Wed, 8 Oct 2008 00:34:18 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Rene Herman" <rene.herman@gmail.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.PjH.L575IB@wind>
In-Reply-To: <yWwteD.A.PjH.L575IB@wind>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080034.19210.elendil@planet.nl>
X-OriginalArrivalTime: 07 Oct 2008 22:34:19.0807 (UTC) FILETIME=[D6BF4AF0:01C928CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 October 2008, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11550
> Subject	: pnp: Huge number of "io resource overlap" messages
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-09-09 10:50 (26 days old)
> References	: http://marc.info/?l=linux-kernel&m=122095745403793&w=4
> Handled-By	: Rene Herman <rene.herman@keyaccess.nl>
> 		  Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122246533505643&w=4

The structural patch for this from Bjorn got NACKed. AFAIK we're still 
waiting for someone (Bjorn?) to decide whether to go with a simpler patch 
from Rene for .27 and to push that.

For me it was possible to work around the issue by changing a BIOS 
setting, but I expect it will still affect others with similar BIOS 
behavior.
