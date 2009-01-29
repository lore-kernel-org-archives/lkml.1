Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZA2Gu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZA2Gu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 01:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZA2Guq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 01:50:46 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:45204 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZA2Gup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 01:50:45 -0500
Subject: Re: [PATCH 5/6] module: make modversion_info contain a pointer,
	not an array.
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
In-Reply-To: <200901290859.40725.rusty@rustcorp.com.au>
References: <200901290005.52819.rusty@rustcorp.com.au>
	 <20090128065231.64d12ffd@infradead.org>
	 <200901290859.40725.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 29 Jan 2009 01:50:23 -0500
Message-Id: <1233211823.3937.1.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 08:59 +1030, Rusty Russell wrote:

> We did discuss changing modversions not to descend more than
> one level deep into types (ie. MODVERSION(int fn(struct foo *))
> would depend on the type of struct foo, but not the type of any
> struct pointers in struct foo) to reduce the problem where header
> changes cause type definitions to be exposed or hidden and thus
> change the modversion.

Yeah. We looked at that for a certain Enterprise Linux distribution but
various people suggested it was more hassle than it was worth to get it
right. I did do some initial poking - I'll dig it up and post it here.

Jon.


