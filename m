Return-Path: <linux-kernel-owner+w=401wt.eu-S966802AbXEHUlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966802AbXEHUlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXEHUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:41:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39494
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933663AbXEHUlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:41:01 -0400
Date: Tue, 08 May 2007 13:41:01 -0700 (PDT)
Message-Id: <20070508.134101.122616112.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bogus section mismatch errors?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070508115220.GA29160@uranus.ravnborg.org>
References: <20070508111759.GA26562@flint.arm.linux.org.uk>
	<20070508115220.GA29160@uranus.ravnborg.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 8 May 2007 13:52:20 +0200

> There are in slab a function that is not marked __init that refer to a function marked
> __init. But the logic surrounding makes it OK.
> 
> I have no fix/workaround for this.
> Andres has suggested that we should mark functions/data that may refer to __init{data}
> with something like: __nowarn and __nowarndata
> 
> I am planning to implement something so we can mark functions/data with:
> __init_ref_ok and _init_data_ref_ok
> Which is indeed more ugly but expalins what is actually OK.
> 
> I hope to take a look during the weekend.

Thanks for working on this, it's the only mismatch I still see
on sparc64 in current GIT :-)
