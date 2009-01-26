Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZAZDAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZAZDAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 22:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZAZDAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 22:00:23 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:49815 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZAZDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 22:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=JSo2By2OsHvw5JkovfRH7ctZ3FmcKs0oYHCL98eDUOm6PzXmy54hAsfvWaIkirASXk
         52ppLOniIXnm1GBB7F7vAXePphipRRh8eaaA9LQ0B7wOD2dcn969hMTDRknpkFWMrEYC
         Yg2qtqllvxwBay8rH5MULNXluAdyyZ2k6AcsY=
Date: Sun, 25 Jan 2009 21:00:17 -0600
From: Jay Cliburn <jcliburn@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>,
       jie.yang@atheros.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [atl2] warn_slowpath in dev_watchdog
Message-ID: <20090125210017.04e38348@osprey.hogchain.net>
In-Reply-To: <884897.63360.qm@web110608.mail.gq1.yahoo.com>
References: <gkt97e$ti0$1@ger.gmane.org>
	<20090117194045.649f55a0@osprey.hogchain.net>
	<767752.95325.qm@web110601.mail.gq1.yahoo.com>
	<20090118095231.2c73c448@osprey.hogchain.net>
	<879024.62535.qm@web110609.mail.gq1.yahoo.com>
	<20090118115858.1b636b2d@osprey.hogchain.net>
	<884897.63360.qm@web110608.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 08:17:25 -0800 (PST)
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> OK the circumstances took a lllllong time to occur again but the result is that
> the patch does not prevent the warning. 

Can you trigger the warning by performing these steps while the interface is up?

unplug cable
ifdown eth0
ifup eth0
replug cable       
wait about 5 seconds...

If it doesn't happen the first time, try 3 or 4 more times.

Let me know what happens.

Thanks,
Jay
