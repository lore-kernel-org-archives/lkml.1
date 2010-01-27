Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489Ab0A0BB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0A0BB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116Ab0A0BB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:01:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58094 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341Ab0A0BB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:01:26 -0500
Date: Wed, 27 Jan 2010 01:02:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rees <drees76@gmail.com>
Cc: Vishal Rao <vishalrao@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
Message-ID: <20100127010204.7976c38b@lxorguk.ukuu.org.uk>
In-Reply-To: <72dbd3151001261632t7bbe43d0nb7490eae02185c81@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	<20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	<aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	<72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
	<aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
	<72dbd3151001261632t7bbe43d0nb7490eae02185c81@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So my concern is that you're proposing to black list NCQ for all users
> of those particular models of SSD when it's more likely at this point
> that it's a problem with your specific setup.

It could even be a Linux side bug or some kind of complicated Linux
timing thing. That *has* happened before with the older IDE stack, so we
need to be cautious, collect reports and try to see patterns before
jumping to conclusions - unless the vendor advises us otherwise.

Alan
