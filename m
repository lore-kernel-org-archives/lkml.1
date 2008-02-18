Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYBRMzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYBRMzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYBRMzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:55:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbYBRMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:55:04 -0500
Date: Mon, 18 Feb 2008 04:53:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wael Nasreddine <mla@nasreddine.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 not working properly.
Message-Id: <20080218045331.ee1dde97.akpm@linux-foundation.org>
In-Reply-To: <20080218045425.GA7381@phoenix.nasreddine.info>
References: <20080218045425.GA7381@phoenix.nasreddine.info>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc linux-wireless)

On Mon, 18 Feb 2008 05:54:25 +0100 Wael Nasreddine <mla@nasreddine.com> wrote:

> Hello,
> 
> I have a Toshiba Satellite A135-S4427 with and Intel 3945ABG card, the
> driver is not working properly.
> 
> When I turn on my PC it works fine, but If I ever bring the interface
> down, I no longer can associate it with any AP without rebooting, even
> the one I was using, I tried rmmod/modprobe iwl3945, didn't do
> anything,
> 
> iwconfig shows that the wlan0 has the radio turned off, and
> 
> $ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
> 1
> 
> Even If I echo 0 > /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
> whenever I try to associate the interface with an AP it turns back to
> 1, I tried both iwconfig and NetworkManager, same problem.
> 
> There's a button on my laptop for Radio SoftKill (fn+F8) but it's not
> working, the soft kill is being enabled/disabled without my
> interference.
> 
> I tried it on kernel-2.6.24 and kernel-2.6.25-rc2 same result...
> 
> Any help is appreciated...
> 
> P.S: Please Cc to me, I am not subscribed to the mailing list.
> 
> -- 
> Wael Nasreddine
> http://wael.nasreddine.com
> PGP: 1024D/C8DD18A2 06F6 1622 4BC8 4CEB D724  DE12 5565 3945 C8DD 18A2
> 
> .: An infinite number of monkeys typing into GNU emacs,
>    would never make a good program. (L. Torvalds 1995) :.
> 
