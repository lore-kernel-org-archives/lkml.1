Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbYLWR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbYLWR4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYLWR4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:56:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52056 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYLWR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:56:08 -0500
Date: Tue, 23 Dec 2008 17:56:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Subject: Re: Perfomance governor is still changing frequency
Message-ID: <20081223175600.GB17426@srcf.ucam.org>
References: <c4e36d110812150515q1c4b2458wa61c79c5a85c624e@mail.gmail.com> <alpine.LFD.2.00.0812151242430.16823@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812151242430.16823@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 12:59:15PM -0500, Len Brown wrote:

> and that will tell us if turbo is related to your
> occasional obervance of low-frequency-mode.

We've observed this on certain other pieces of modern Intel hardware - 
the best hypothesis we've been able to come up with is that if the msr 
read is the first instruction run on the core when it's previously been 
in a deep C state, the low-clock speed is reported. However, some 
Thinkpads will also automatically limit their speed for thermal reasons.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
