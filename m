Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZK3PfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZK3PfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZK3PfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:35:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZK3PfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:35:15 -0500
Date: Mon, 30 Nov 2009 10:35:17 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <681767146.799121259595317411.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1652946445.798701259595233406.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: crash driver in fedora
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Christoph Hellwig" <hch@lst.de> wrote:

> Hi Dave,
> 
> is there a good reason the crash driver is still only stuck in the
> Fedora kernel instead of beeing upstream?  We already have the
> restrictive memory device options upstream, so there should be a use
> case for it.

(FWIW, it made it into Fedora long after it was introduced in RHEL...)

Anyway, Bernard Walle's request made far more sense than the crash driver,
and his patch was ultimately rejected: 
 
  http://lkml.org/lkml/2008/11/16/117
  From:     Bernhard Walle <>
  Subject:  Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
  Date:     Sun, 16 Nov 2008 15:47:45 +0100

So I'm guessing that the crash driver, which is a read-only workaround
for CONFIG_STRICT_DEVMEM kernels, would suffer the same fate.

Dave
