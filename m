Return-Path: <linux-kernel-owner+w=401wt.eu-S1161366AbXDQWSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161366AbXDQWSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161375AbXDQWSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:18:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57691 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161366AbXDQWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:18:03 -0400
Date: Wed, 18 Apr 2007 00:18:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
Message-ID: <20070417221801.GE11944@one.firstfloor.org>
References: <1176708094.22969.7.camel@dual.local> <p734png6s1t.fsf@bingen.suse.de> <Pine.OSF.4.64.0704162337320.487506@kosh.hut.fi> <20070416214042.GB25508@one.firstfloor.org> <Pine.OSF.4.64.0704171058040.487506@kosh.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.OSF.4.64.0704171058040.487506@kosh.hut.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It could be done in one scanning loop provided that it is quaranteed that 
> the nvidia chipset is always before the the hpet quirk chip in pci 
> hierarchy. Then the nvidia quirk needs to be split to two parts, of which 

You just only set flags for both in the scanning loop and then handle
it after every device has been visited.

It's a simple state machine.

-Andi
