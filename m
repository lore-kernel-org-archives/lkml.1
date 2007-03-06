Return-Path: <linux-kernel-owner+w=401wt.eu-S965028AbXCFOEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028AbXCFOEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965030AbXCFOEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:04:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58839 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbXCFOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:04:14 -0500
Date: Tue, 6 Mar 2007 15:04:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: shemminger@linux-foundation.org, andi@firstfloor.org,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support II
Message-ID: <20070306140412.GA1470@one.firstfloor.org>
References: <20070226143127.5c74bec9@freekitty> <p73slcnawh3.fsf@bingen.suse.de> <20070305155714.3abe1b5e@freekitty> <20070305.162551.41660347.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305.162551.41660347.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem with these algorithms that tradoff one or more
> multiplies in order to avoid a divide is that they don't
> give anything and often lose when both multiplies and
> divides are emulated in software.

Actually on rereading this: is there really any Linux port
that emulates multiplies in software? I thought that was only
done on really small microcontrollers or smart cards; but anything
32bit+ that runs Linux should have hardware multiply, shouldn't it?

-Andi
