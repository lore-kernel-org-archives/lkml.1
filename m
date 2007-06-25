Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbXFYMNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbXFYMNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXFYMNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:13:48 -0400
Received: from saeurebad.de ([85.214.36.134]:47893 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXFYMNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:13:47 -0400
Date: Mon, 25 Jun 2007 14:13:16 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: vignesh babu <vignesh.babu@wipro.com>
Cc: daniel.pirkl@email.cz, dushistov@mail.ru,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Subject: Re: [PATCH]is_power_of_2-ufs/super.c
Message-ID: <20070625121316.GA19544@saeurebad.de>
Mail-Followup-To: vignesh babu <vignesh.babu@wipro.com>,
	daniel.pirkl@email.cz, dushistov@mail.ru,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Kernel Janitors List <kernel-janitors@lists.osdl.org>
References: <1181808559.2474.9.camel@merlin.linuxcoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181808559.2474.9.camel@merlin.linuxcoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 14, 2007 at 01:39:18PM +0530, vignesh babu wrote:
> Replacing (n & (n-1)) in the context of power of 2 checks
> with is_power_of_2

You might want to run

	egrep -R '([a-zA-Z0-9_.>]+) *& *\(\1 *- *1\)' /usr/src/linux

This does not match if the check is broken into multiple lines, though.
Still, 66 matches so far. Perhaps a big patch that removes most of these
occurrences would be more appropriate.

	Hannes
