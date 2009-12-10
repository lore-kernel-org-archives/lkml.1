Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZLJQ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZLJQ3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760970AbZLJQ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:29:19 -0500
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:60743 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756402AbZLJQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:29:18 -0500
Message-ID: <4B2121E2.2030900@moving-picture.com>
Date: Thu, 10 Dec 2009 16:29:22 +0000
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: High load average on idle machine running 2.6.32
References: <4B1D8C5D.9040900@moving-picture.com>
In-Reply-To: <4B1D8C5D.9040900@moving-picture.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Pearson wrote:
> I've booted a 64 bit 2.6.32 kernel on dual processor, quad core Xeon 
> E5440 machine. The load average when the machine is idle varies between 
> 2 and 3.
> 
> When using a 2.6.31 kernel on the same machine, the load average when 
> idle is nearly 0
> 
> The kernel doesn't use modules - all that is needed is compiled in. The 
> machine uses NFS-root
> 
> Strangely, when I run 'iftop' (from http://www.ex-parrot.com/pdw/iftop/) 
> using the 2.6.32 kernel, the load average drops to below 0.5  - stop 
> running iftop, and the load average climbs again ...
> 
> Any idea what might be causing this?

It looks like whatever is causing this happened between 2.6.31-git7 and 
2.6.31-git8 - unfortunately I don't know how to find out what change 
caused this ...

Also, if I 'hot-unplug' CPUs 1 to 7, the load average drops to 0 - when 
I re-enable theses CPUs, the load average climbs.

I guess this is a problem with my particular config - or maybe because 
I'm using NFS-root (the root file system is readonly), or using a 
non-module kernel?

Thanks

James Pearson
