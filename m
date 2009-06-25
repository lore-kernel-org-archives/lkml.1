Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZFYNoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZFYNoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFYNob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:44:31 -0400
Received: from mailhost18.gawab.com ([66.220.20.18]:34613 "HELO
	info3.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751160AbZFYNob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:44:31 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: io-scheduler tuning for better read/write ratio
Date: Thu, 25 Jun 2009 16:45:40 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
References: <4A37CB2A.6010209@davidnewall.com> <200906241057.41227.a1426z@gawab.com> <20090625072641.GB16642@p15145560.pureserver.info>
In-Reply-To: <20090625072641.GB16642@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906251645.40705.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Gross wrote:
> Al Boldi schrieb:
> > Try changing /proc/sys/vm/dirty_ratio = 1
>
> $cat /proc/sys/vm/dirty_ratio
> 1
>
>
> $dstat -D md1 -d 5
> --dsk/md1--
> _read _writ
>   18M   18M
>    0     0
>  820k  101M
>   18M  113M
>   26M   73M
>   26M  110M
>   32M  100M
>   19M  111M
>   13M  117M
>   13M  142M
>   32M   88M
>   26M   99M
>   38M   58M
>
> No change. Even setting dirty_ratio to 100 didn't show any difference.

What's your readahead?  Do a blockdev --getra /dev/sdX and /dev/mdX.
Try increasing it, while keeping dirty_ratio low.


Thanks!

--
Al


