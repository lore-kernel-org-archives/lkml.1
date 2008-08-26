Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYHZOna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYHZOna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYHZOnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:43:07 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64046 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756599AbYHZOnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:43:07 -0400
Date: Tue, 26 Aug 2008 15:42:46 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Steven A. Falco" <sfalco@harris.com>
cc: Will Newton <will.newton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Driver for Real Time Clock chip ST M41T65
In-Reply-To: <48B40B68.1040607@harris.com>
Message-ID: <Pine.LNX.4.55.0808261524590.28361@cliff.in.clinika.pl>
References: <48B2EB77.9000103@harris.com> <87a5b0800808260130i383ec8d0y45690f85366c5059@mail.gmail.com>
 <48B40B68.1040607@harris.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Steven A. Falco wrote:

> I'd also like to know if I should submit a new driver or mod the existing
> one.  If I mod the existing one, should it be renamed, should I update the
> Kconfig, existing defconfigs, etc?

 Keeping the code base common is good for maintenance.  Therefore for a 
minor differences like yours there is no doubt you better just add them to 
the existing driver.

 For larger variations -- it depends, i.e. it's better to keep the common
bits shared, unless the maintenance cost of such an approach exceeds that
of the other one.  Frequently it just boils down to doing it right which
may not necessarily be easy. ;)

  Maciej
