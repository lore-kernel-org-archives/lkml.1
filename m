Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbZLONLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbZLONLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZLONLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:11:36 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:53100 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZLONLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:11:36 -0500
Message-ID: <4B278B05.1090403@ladisch.de>
Date: Tue, 15 Dec 2009 14:11:33 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: suspect & tests
References: <1260818577.18538.35.camel@Joe-Laptop.home>
In-Reply-To: <1260818577.18538.35.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> A grep for possibly misused & tests
> 	grep -rP --include=*.[ch] -n -e "[^\&]\&[\=]*\s*\!" *
> shows some possible cases where && should
> have been used instead:
> ...
> sound/soc/codecs/stac9766.c:233:		vra &= !0x04;

This looks like ~ should have been used.
