Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbXKNBYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbXKNBYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXKNBYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:24:36 -0500
Received: from gw.goop.org ([64.81.55.164]:44960 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXKNBYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:24:36 -0500
Message-ID: <473A4DDE.4090404@goop.org>
Date: Tue, 13 Nov 2007 17:22:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Tobias Powalowski <t.powa@gmx.de>, linux-kernel@vger.kernel.org,
       Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
References: <200711131139.42791.t.powa@gmx.de> <473A073C.2020201@goop.org> <20071113222212.GA1322@infradead.org>
In-Reply-To: <20071113222212.GA1322@infradead.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> NACK, both of these are internal and graphics drivers should not be
> using them.
>   

I don't feel very strongly about it either way.  I think the two
arguments for it are:

   1. it's a regression compared to previous kernels
   2. it's a visible difference between CONFIG_PARAVIRT and
      non-CONFIG_PARAVIRT

Arguments against are all the usual ones.

    J

