Return-Path: <linux-kernel-owner+w=401wt.eu-S934801AbZJOR72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbZJOR72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbZJOR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:59:27 -0400
Received: from khc.piap.pl ([195.187.100.11]:49507 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbZJOR71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:59:27 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: ddutile@redhat.com
Cc: Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>
	<m3ljjdstbb.fsf@intrepid.localdomain> <4AD62B52.9060200@redhat.com>
	<m33a5lsls1.fsf@intrepid.localdomain> <4AD655E1.7080005@redhat.com>
Date: Thu, 15 Oct 2009 19:58:49 +0200
In-Reply-To: <4AD655E1.7080005@redhat.com> (Don Dutile's message of "Wed, 14
	Oct 2009 18:51:13 -0400")
Message-ID: <m3y6nc1que.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Dutile <ddutile@redhat.com> writes:

>>> No matter how many lanes, or how the data is sent (long or short bursts),
>>> the frequency rate is a constant.

I'm not sure there is such thing as "frequency rate" (but English isn't
my first language). Rate, yes - symbol rate, clock rate (not used here),
code rate. Frequency is a clearly defined but different thing.

> Frequency changing would require link re-synch.
> This code is dealing w/steady-state frequency.

Believe me or not, there is no single frequency on PCIe link.

Google shows for example:
http://www.home.agilent.com/upload/cmc_upload/All/PCIe_HighSpeedSymposiumDec2008.pdf

See page 30, it's frequency spectrum for PCIe 3.0 but the idea is the
same. Also note consistent use of "GT/s" to avoid confusion.

> Again, trying to generate output that relates
> to what devices are spec to run at: 2.5GHz or 5.0GHz links.

That seems like wifi rather than PCIe.
-- 
Krzysztof Halasa
