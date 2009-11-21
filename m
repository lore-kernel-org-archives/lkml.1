Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZKUOHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZKUOHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 09:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZKUOHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 09:07:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52797 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754484AbZKUOHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 09:07:11 -0500
Date: Sat, 21 Nov 2009 14:09:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mfuzzey@gmail.com
Cc: linux-serial@vger.kernel.org, tsbogend@alpha.franken.de,
       linux-kernel@vger.kernel.org
Subject: Re: Serial: sc26xx device name
Message-ID: <20091121140911.0e7ef3fd@lxorguk.ukuu.org.uk>
In-Reply-To: <4B07F068.1090801@gmail.com>
References: <4B07F068.1090801@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So two questions:
> 1) Who is right (the driver or devices.txt)?

devices.txt has all the officially properly registered values

> 2) How are device name conflicts handled?

Badly - they should never occur but if someone didn't properly reserve
the namespace they can and then whoever forgot to reserve the namespace
loses.
