Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbZE0Jsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbZE0Jsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbZE0JsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:48:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53272 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759153AbZE0JsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:48:20 -0400
Date: Wed, 27 May 2009 10:49:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Frans Pop <elendil@planet.nl>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Message-ID: <20090527104913.644e6970@lxorguk.ukuu.org.uk>
In-Reply-To: <20090526180821.GB13276@ub>
References: <200905252344.11826.bzolnier@gmail.com>
	<200905260106.13705.elendil@planet.nl>
	<200905261423.40117.bzolnier@gmail.com>
	<200905261453.22428.elendil@planet.nl>
	<20090526140132.19e8bc13@lxorguk.ukuu.org.uk>
	<20090526180821.GB13276@ub>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Probably I am missing some context, but the above seems to be
> a false statement. The PC partition format does give you
> start and size, and no filesystem knowledge is needed to
> find out where a partition ends.

I am indeed in error. The PC DOS format is indeed fine. I was
remembering from the magneto-opticals and the problem there was you
couldn't tell the size because there were two conflicting standards for
partition encoding.

So that means a distro can detect some of the cases which is even better
and makes a sysfs interface even more useful.

Alan
