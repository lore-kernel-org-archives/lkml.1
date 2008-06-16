Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbYFPPWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbYFPPWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYFPPV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:21:58 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:22334 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYFPPV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:21:57 -0400
Message-ID: <48568503.90607@codemonkey.ws>
Date: Mon, 16 Jun 2008 10:21:39 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
References: <20080616150550.GA16086@deprecation.cyrius.com>
In-Reply-To: <20080616150550.GA16086@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> When I start a guest in vmplayer, my laptop locks up hard.  I found
> out that this only happens when the kvm-intel module has been loaded.
> When I unload this module, I can start vmware guests just fine.
>
> I see this problem on a HP Compaq 2510p notebook with Intel Core2 Duo
> U7600 @ 1.20GHz, but http://laptop006.livejournal.com/41314.html
> describes exactly the same problem on a Lenovo T61 (custom build),
> Core 2 T7500 on a Santa Rosa.  I've seen this with at least 2.6.24 and
> 2.6.25.
>
> I don't have a serial console, but I started VMplayer and
> immediately switched to the console but nothing is displayed
> (i.e. no kernel panic; it simply locks up hard).
>
> Any idea if this is a kernel bug, BIOS issue or a bug in VMplayer?
>   

This has been fixed in the latest KVM code base AFAIK.

Regards,

Anthony Liguori


