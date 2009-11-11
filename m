Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbZKKWFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbZKKWFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbZKKWFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:05:51 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:61853 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759400AbZKKWFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:05:50 -0500
From: Frans Pop <elendil@planet.nl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: large packet loss take2 2.6.31.x
Date: Wed, 11 Nov 2009 23:05:53 +0100
User-Agent: KMail/1.9.9
Cc: Caleb Cushing <xenoterracide@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <81bfc67a0910310721p21046931o9b512cfd0a8a7acb@mail.gmail.com> <81bfc67a0911111219m1efff30cr3186987f9dbb3d4d@mail.gmail.com> <878wecka3g.fsf@basil.nowhere.org>
In-Reply-To: <878wecka3g.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911112305.54824.elendil@planet.nl>
X-OriginalArrivalTime: 11 Nov 2009 22:05:55.0206 (UTC) FILETIME=[23F5D260:01CA631B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Andi Kleen wrote:
> Caleb Cushing <xenoterracide@gmail.com> writes:
> >> I'm attaching the bisection log and a 'good' dmesg output.
> >>
> >> c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9 is the first bad commit
>
> Just gives fatal: bad object c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9
> here on a standard Linus linux-2.6 tree.

Looks to be a commit from a stable update:

commit c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Tue Sep 1 11:38:34 2009 -0400

    usb-serial: change referencing of port and serial structures

    commit 41bd34ddd7aa46dbc03b5bb33896e0fa8100fe7b upstream.

Cheers,
FJP
