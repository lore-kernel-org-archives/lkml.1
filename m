Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYEPHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYEPHyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYEPHx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:53:57 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:15176 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYEPHx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EQBeHPkeJEWqGTMtUA7uWyQUn7k89jTQKvrWgqxXC6LzXNCk8FueHoX8huQftMT9W9FBELBjfanHpUPVt66MZ1AVczUpnXxxWRloQ3WS7U0dFe5/+c+xLXj6ieNdqSh2P2PIan4Zp6yPhEtSEacsLW7WNfb+Uxf6MqhNlI1xRdg=
Message-ID: <569c97d20805160053n8a5deceu25c8b37f02e02842@mail.gmail.com>
Date: Fri, 16 May 2008 13:23:52 +0530
From: "Balaji Rao R" <balajirrao@gmail.com>
To: "Kevin Hao" <kexin.hao@windriver.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
Cc: venkatesh.pallipadi@intel.com, clemens@ladisch.de, bob.picco@hp.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1210917912.10881.1.camel@kevin-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210917912.10881.1.camel@kevin-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 11:35 AM, Kevin Hao <kexin.hao@windriver.com> wrote:
>
> Hi,
>
> x86: get irq for hpet timer
>
> HPET timer's IRQ is 0 by default, so we have to select which irq
> will be used for these timers. We wait to set the timer's irq until
> we really turn on interrupt in order to reduce the chance of
> conflicting with some legacy device.
>
Yes, this is alright. But  i've seen some machines where we have a
valid IRQ in 'devp->hd_hdwirq' which you should not ignore. So, first
check if it is zero and only then do a hpet_timer_get_irq.

--
warm regards

Balaji Rao
NITK Surathkal
