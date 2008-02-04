Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYBDAct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYBDAct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbYBDAcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:32:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbYBDAck convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:32:40 -0500
Date: Sun, 3 Feb 2008 16:32:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toralf =?ISO-8859-1?B?RvZyc3Rlcg==?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, cpufreq@www.linux.org.uk
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Message-Id: <20080203163255.467256d4.akpm@linux-foundation.org>
In-Reply-To: <200801261506.28544.toralf.foerster@gmx.de>
References: <200801261506.28544.toralf.foerster@gmx.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008 15:06:25 +0100 Toralf Förster <toralf.foerster@gmx.de> wrote:

> I use a 1-liner for a simple performance check : "time factor 819734028463158891"
> Here is the result for the new (Gentoo) kernel 2.6.24:
> 
> With the  ondemand governor of the  I get:
> 
> tfoerste@n22 ~/tmp $ time factor 819734028463158891
> 819734028463158891: 3 273244676154386297
> 
> real    0m32.997s
> user    0m15.732s
> sys     0m0.014s
> 
> With the ondemand governor the CPU runs at 600 MHz,
> whereas with the performance governor I get :
> 
> tfoerste@n22 ~/tmp $ time factor 819734028463158891
> 819734028463158891: 3 273244676154386297
> 
> real    0m10.893s
> user    0m5.444s
> sys     0m0.000s
> 
> (~5.5 sec as I expected) b/c the CPU is set to 1.7 GHz.
> 
> The ondeman governor of previous kernel versions however automatically increased
> the CPU speed from 600 MHz to 1.7 GHz.
> 
> My system is a ThinkPad T41, I'll attach the .config 
> 

Let's cc the cpufreq list.

If nothing happens (often the case), please raise a report at
bugzilla.kernel.org so we can track the presence of the regression.

Thanks.

