Return-Path: <linux-kernel-owner+w=401wt.eu-S376147AbXECPoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376147AbXECPoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376152AbXECPoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:44:13 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:47665 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S376147AbXECPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:44:12 -0400
In-Reply-To: <200705030948.03984.arnd@arndb.de>
References: <20070503065435.4533.64938.stgit@localhost.localdomain> <200705030948.03984.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5a7e02f6d1520d8ad02e28ace218981c@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Date: Thu, 3 May 2007 17:43:38 +0200
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> +               pcmcia@0080 {

>> +                       compatible = "8xx";

> The compatible property should be a little more specific, imho. Since 
> there
> are differences in how things are done depending on the board, it 
> would be
> good to tell the exact method from the pcmcia node itself.

Just "8xx" isn't good enough -- at a very minimum it
needs to say this is a PCMCIA controller!

> For example, you could make this
>
> 	compatible = "8xx\0mpc885ads";

"mpc885ads-pcmcia\0mpc8xx-pcmcia" or something like that.


Segher

