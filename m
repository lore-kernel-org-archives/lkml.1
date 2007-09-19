Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbXISI1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbXISI1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbXISI04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:26:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbXISI0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:26:55 -0400
To: "Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Problem: one driver and 4 instances with different parameters
References: <016a01c7fa89$ff51e850$b4fefea9@andrey>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 10:26:54 +0200
In-Reply-To: <016a01c7fa89$ff51e850$b4fefea9@andrey>
Message-ID: <p73abrjvz5d.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de> writes:

> I have one driver, but I need to run 4 instances of it (I run insmod
> with different parameters) .
> 
> But when I try to install the second driver I've got an error, that
> driver with this name exists.

The standard trick to do that is to copy the module binary to four different
names (the module name is not encoded in the binary)

But it would be better to just fix the driver to allow this
with a single instance with some other run time configuration
mechanism and not use module parameters (which 
are generally somewhat deprecated anyways) 

-Andi

