Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157Ab0A3PYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0A3PYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115Ab0A3PYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:24:54 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57254 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0A3PYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=i4o9mXgJFqmD0YSVq67MVZL4aQLYXbbxKm9wn1rymV8gNM1NNcyCkx8OenpWFGtDNz
         H0I2J7kcdIVZ7WwDO73+8uVLLOHi36+VqSibSRMbDAkDHAIStZBxuGeMs/Cz+PJCJIme
         yd0Doyt4ciduKRMyRI4xyjjpypqvfQGHbb86Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/68] ide2libata
Date: Sat, 30 Jan 2010 16:24:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100129160308.21495.14120.sendpatchset@localhost> <4B6355DF.9050001@garzik.org> <20100129232540.41f6c4f6@lxorguk.ukuu.org.uk>
In-Reply-To: <20100129232540.41f6c4f6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <201001301624.10174.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 January 2010 12:25:40 am Alan Cox wrote:

> So I think its an extremely useful exercise to figure out what subtle
> differences there are between the drivers. It's not then a trivial
> assumption that they can just be pasted over. The include stuff though is

Fully agreed, that is why a fair deal of review work went into making
sure that porting of a each driver to ide2libata doesn't cause functionality
changes.

> too ugly to merge even if its an excellent research project to identify
> the differences and quirks.

Well, looks acceptable to me when the alternative is a duplicated code
(though I don't insists on getting it merged anyway)..

--
Bartlomiej Zolnierkiewicz
