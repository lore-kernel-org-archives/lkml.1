Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZFGWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZFGWZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 18:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZFGWZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 18:25:30 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61938 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZFGWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 18:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nBLdSr0e4NgQgQ69fubcNjPJNpaV+VDnI4WQOUgwi0/0ons+OZivsYWwO75+2MAWtf
         K2831c2oVxzcqGjh6JMcO36H4hW0psn2OepaO5wvVzlcVGuS3ykRR+jN/Lm269UmPIwM
         LonwExKbSKcYGkNVqi/F5ry67/MRm4jPUco2M=
MIME-Version: 1.0
In-Reply-To: <20090607214559.GD7785@n2100.arm.linux.org.uk>
References: <1244399935-23128-1-git-send-email-baruch@tkos.co.il>
	 <63386a3d0906071433h516ee358ud2e64a90692fa4f9@mail.gmail.com>
	 <20090607214559.GD7785@n2100.arm.linux.org.uk>
Date: Mon, 8 Jun 2009 00:25:30 +0200
Message-ID: <63386a3d0906071525i3ad6f274l2ae2c2b956010fc3@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: driver for PrimeCell PL061 GPIO controller
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:

>> Yes but defined a new one 4*1024 instead, but I'll show, hang on...
>
> Hint: it got changed because we don't want to use SZ_4K in drivers which
> can be used externally to ARM.

OK then my most recent patch does away with some of that burden too...

Linus Walleij
