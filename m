Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbXFGQTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbXFGQTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXFGQS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:18:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbXFGQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:18:58 -0400
Message-ID: <46682FED.2080506@zytor.com>
Date: Thu, 07 Jun 2007 09:18:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Lyon <andrew.lyon@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>	 <20070606143723.GF10008@csclub.uwaterloo.ca>	 <46673135.30105@zytor.com> <f4527be0706061541ifd49a8fg60442532d72f1d06@mail.gmail.com>
In-Reply-To: <f4527be0706061541ifd49a8fg60442532d72f1d06@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lyon wrote:
> 
> Could this also cause a system to be unstable? my abit athlon64 at
> work will not run x64 with more than 1gb ram, and i have a colo server
> with supermicro & 2 x dual core xeons that will not run with more than
> 2gb.
> 
> Both systems have long uptimes but if i add ram they crash within
> minutes of booting.
> 

That's much more likely to be caused by bad memory bus layout so that it
doesn't handle the higher loading.

Run memtest86+ on the expanded memory for some time.

	-hpa
