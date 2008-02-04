Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYBDKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYBDKm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYBDKmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:42:37 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:48754 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751029AbYBDKmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:42:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6kQ3u2OIffbYLokEPM6XvCr/5iX7IHxQ37pNdIjsVhMxT2EHqRUvrQLFKU3/oJzpnu1Vg0Zu3LX/JP3PgZYYv4TXT6KKTbZy5qo1bF23ZTBhWfzdnBh3NQDSy6T2EcLkToBeF9NOp1qP4JxDADUuizk5vq+r6TbbIhnjKjy62PA=  ;
X-YMail-OSG: 58p0oLYVM1kOhYswA4AKjqdaSm1kH4P0hWqYhXDmMEV9SYfxPegFqFGssVVd_zCvc8xbcQXDew--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Robin Lee Powell <rlpowell@digitalkingdom.org>
Subject: Re: Monthly md check == hung machine; how do I debug?
Date: Mon, 4 Feb 2008 21:40:55 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20080203212155.GF12173@digitalkingdom.org>
In-Reply-To: <20080203212155.GF12173@digitalkingdom.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042140.55521.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008 08:21, Robin Lee Powell wrote:
> I've got a machine with a 4 disk SATA raid10 configuration using md.
> The entire disk is loop-AES encrypted, but that shouldn't matter
> here.
>
> Once a month, Debian runs:
>
>     /usr/share/mdadm/checkarray --cron --all --quiet
>
> and the machine hangs within 30 minutes of that starting.
>
> It seems that I can avoid the hang by not having "mdadm --monitor"
> running, but I'm not certain if that's the case or if I've just been
> lucky this go-round.
>
> I'm on kernel 2.6.23.1, my own compile thereof, x86_64, AMD
> Athlon(tm) 64 Processor 3700+.
>
> I've looked through all the 2.6.23 and 2.6.24 Changelogs, and I
> can't find anything that looks relevant.
>
> So, how can I (help you all) debug this?

Do you have a serial console? Does it respond to pings?

Can you try to get sysrq+T traces, and sysrq+P traces, and post
them?
