Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXLSBHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXLSBHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXLSBHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:07:00 -0500
Received: from mout1.freenet.de ([195.4.92.91]:39831 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbXLSBG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:06:59 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC/PATCH] 2.6.24-rcx: Make sys_poll() wait at least timeout ms
Date: Wed, 19 Dec 2007 02:06:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org
References: <fa.QbT8/KZb1MTA5+n7SD6kFi6mqso@ifi.uio.no> <47685F4B.8000207@shaw.ca>
In-Reply-To: <47685F4B.8000207@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712190206.56428.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 19. Dezember 2007 schrieb Robert Hancock:
> 
> That seems fishy. What is your value of HZ and what is the timeout value 
> that was passed in the bad case?

HZ set to 250, timeout to 4ms.
Time spent in poll() taken by clock_gettime(CLOCK_MONOTONIC, &time)
before and after poll()call: i.e 62us.
Time measured with hpet gave 166us once.

      Karsten

