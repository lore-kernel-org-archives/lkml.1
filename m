Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYJFRyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYJFRyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYJFRyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:54:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:5851 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYJFRyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n0RLjDhOlwlmgsSf3YhGWd+GzLXPb1Hh67hXPNUTk8kfv3KyVz8C5I7bXMkiwG04jY
         fU0i6ApjBK8RERxJbpmr/8fuc0Ad2tZldVIZ+EEK2O+8kpifxGHE+lgFL706emTRz7Hr
         OF7hzoXW7OxE0XA1vAy7dOKOPPWlTi4zkBnfw=
Date: Mon, 6 Oct 2008 21:54:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Batyiev <batyiev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: APIC misconfiguration
Message-ID: <20081006175417.GC7317@localhost>
References: <200810061923.09076.batyiev@gmail.com> <200810061955.28915.batyiev@gmail.com> <20081006171742.GB7317@localhost> <200810062030.42952.batyiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810062030.42952.batyiev@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrey Batyiev - Mon, Oct 06, 2008 at 08:30:42PM +0300]
| > hmm... don't we have any ISA quirks already? If this device support
| > PnP there should be descriptor for irq line where you could change it
| > since I don't believe it would be a first device in kernel which behave
| > not as supposed and developers has to override some configs bits.
| > Hope it help (i didn't check ISA code though -- too busy now).
| 
| Well, it seems device haven't either PnP or isapnp doesn't detect it.
| 
| Thanks,
|    Andrey
| 

Lets better wait for advices for other developers. Writting directly
to io-apic routing table is not a good idea i think. Some quirks
should be involved.

		- Cyrill -
