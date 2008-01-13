Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYAMX5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYAMX5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 18:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYAMX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 18:57:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:24742 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYAMX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 18:57:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RvM/lEAQ/izBSZ1XWzj9Va2e0ssaz2X2ajyNxHCSCYbwJav/+qAJ53Sn0ZB8Se3gwzxeoLfFr1fKT7xKHRszmaxMZbWVucS32m/CMR+xl/1fRxLAUoa/9bRo9mWDWb7nLSXXyYlM+0roLK2JovoVwESn6GBQ1hlk3N+BOftTHmo=
Message-ID: <478AA56F.9020506@gmail.com>
Date: Mon, 14 Jan 2008 08:57:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
CC: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>	<20080108015012.2e518dd4@werewolf>	<478429B2.2030002@gmail.com>	<20080110102505.62097da1@werewolf>	<47861930.7010708@gmail.com> <20080114001914.1e05fdb5@werewolf>
In-Reply-To: <20080114001914.1e05fdb5@werewolf>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> I'm still pending to pysically remove the disks (or at least unplug the
> cable...), but I have realized a cusious thing: after some errors, the
> kernel is lowering the disk speed (UDMA/133, then 100, then 33):

That's the standard error handling behavior.  Timeouts are likely to
indicate transmission problems so libata puts it into slower gear.

> Perhaps this gives a clue.
> Or I just had bad luck and 2 of my 4 disks broke at the same time.

As I said, the first thing I would try is to connect the drives to a
separate PSU and re-seating cables as you're seeing problems on two
drives simultaneously.

-- 
tejun
