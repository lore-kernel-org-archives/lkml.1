Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXKLNDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXKLNDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758344AbXKLNDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:03:40 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:35247 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbXKLNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:03:39 -0500
Subject: Re: Module init call vs symbols exporting race?
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jon Masters <jonathan@jonmasters.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <200711101827.47874.rusty@rustcorp.com.au>
References: <473031FA.2060707@openvz.org>
	 <1194608640.9377.104.camel@perihelion>
	 <1194610607.5000.9.camel@localhost.localdomain>
	 <200711101827.47874.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 14:03:21 +0000
Message-Id: <1194876201.5656.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-11-10 at 18:27 +1100, Rusty Russell wrote:
> We fail rather than sleep in the "dependency isn't ready" case.  Partially 
> because it's not happened before, but partially because we risk nasty loops.

If we fail since we have to in the "dependency isn't ready" case then
the warning seems quite useless. I'll send a patch in a seperate mail
to remove the warning.

-jang

