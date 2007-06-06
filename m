Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbXFFFoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbXFFFoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934680AbXFFFno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:43:44 -0400
Received: from bay0-omc3-s2.bay0.hotmail.com ([65.54.246.202]:24692 "EHLO
	bay0-omc3-s2.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934679AbXFFFnn (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:43:43 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Wed, 6 Jun 2007 01:43:45 -0400
From: Sean <seanlkml@sympatico.ca>
To: Linux-Kernel@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tejun Heo <htejun@gmail.com>, Adrian Bunk <bunk@stusta.de>
Subject: rc4 libata regression - commit 464cf177
Message-Id: <20070606014345.787c6efc.seanlkml@sympatico.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 05:43:55.0093 (UTC) FILETIME=[AB9A5050:01C7A7FD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jeff,

Don't see a fix for this issue in your tree, although i think someone
else may have already reported this.   Just thought better safe than
sorry and report perhaps again that rc4 can't boot here because the
sata drives can not be found.  Reverting commit 464cf177 fixes the
problem.

As an aside, booting the patch-reverted rc4 does not resolve the other
issue I just reported to the list[1] (sorry for not cc'ing you).

Cheers.
Sean

[1] http://marc.info/?l=linux-kernel&m=118109439301092&w=2
