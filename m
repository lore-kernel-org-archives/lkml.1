Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYHJHcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYHJHcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYHJHcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:32:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:16454 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYHJHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=maE7zYsmbnVbUDgy0wThSeZ5TWTTAsokIeuS7gDovfa99dBfBVMwXRNTqhBEDkVQ6m
         xvStKeuDR+hOKj2f3H5uDOZJ5HjukrWQQ8WwKaNKtXhr4JNq9TYv7pcgFkLGt4XApYyB
         NAQheiEcw+Q6te/GNaXcfDIrqrHhcuBMErlqk=
Date: Sun, 10 Aug 2008 11:32:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Bradley Hanna <brahan.ml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Programming the apic when no external to cpu timer is present?
Message-ID: <20080810073207.GB7249@lenovo>
References: <489E341F.2030809@gmail.com> <20080810072838.GA7249@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810072838.GA7249@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Aug 10, 2008 at 11:28:38AM +0400]
| [Bradley Hanna - Sat, Aug 09, 2008 at 08:19:43PM -0400]
| | I am working with an embedded testing board that has no timer external
| | to the cpu other than an rtc.  How does linux go about programming the
| | local cpu timer (apic) to raise hardware interrupts?
| | 
| | thanks for your patience,
| | 
| | brahan
| | 
| 
| you could take a look on apic_(32|64).c. Here is the
| function you need I hope - setup_APIC_timer
| 
| 		- Cyrill -

oops - it should be lapic_timer_setup :)

		- Cyrill -
