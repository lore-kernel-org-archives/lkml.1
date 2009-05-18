Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZERWfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZERWfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 18:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZERWfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 18:35:14 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:42918 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbZERWfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 18:35:13 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 822B53CA1FE
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH] sysrq: Don't panic_on_oom if the user requested an OOM  kill.
To: David Rientjes <rientjes@google.com>, Geoffrey Thomas <geofft@mit.edu>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 19 May 2009 00:35:11 +0200
References: <cD8Tq-1IB-7@gated-at.bofh.it> <cDi6w-7CM-27@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1M6BQO-0001j9-7h@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> wrote:
> On Mon, 18 May 2009, Geoffrey Thomas wrote:

>> If I specifically request an OOM kill via magic sysrq, I don't want
>> panic_on_oom to apply and crash the machine. I ran into this on a server
>> with panic_on_oom and automatic reboot after panic configured on the
>> assumption that nobody is likely physically present. If I'm able to use
>> magic sysrq, though, I can use that to reboot the machine slightly more
>> safely, if that's what I wanted.
>> 
>> This patch adds an extra parameter to out_of_memory to ignore the value
>> of sysctl_panic_on_oom, and just proceed with the OOM kill.
>> 
>> Signed-off-by: Geoffrey Thomas <geofft@mit.edu>
> 
> Nack, it's your own fault for asking for panic_on_oom and then not wanting
> it to panic on oom.
> 
> Disable /proc/sys/vm/panic_on_oom before invoking the oom killer and then
> reenable it afterwards.

Did you even think about the reasons for pressing sysrq-foo?
Like - e.g. - NOT BEING ABLE TO LOG IN?

