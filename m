Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZDKBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZDKBHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZDKBHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:07:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:14286 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZDKBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Exa2yQ+1nmYTN3GbQjSlirJIZ/zRX0WmeBIrHO2JOjSPI4KhKhape4q9r9uZ48kjeP
         mQHNZnvsVMJ40LfUlrPj3MOQLKZZR4Q6yuNF3lal2R1rNZhGcmJkrRDx/s6JBPe2byMO
         haP0xbIeCwEMtWk/j0WCrBISjXkOYNozF2G7U=
MIME-Version: 1.0
In-Reply-To: <20090410095246.4fdccb56@s6510>
References: <Pine.LNX.4.64.0904101656190.2093@boston.corp.fedex.com>
	 <20090410095246.4fdccb56@s6510>
Date: Sat, 11 Apr 2009 09:07:02 +0800
Message-ID: <b6a2187b0904101807x77578e0dhd0093d233839ef67@mail.gmail.com>
Subject: Re: iptables very slow after commit784544739a25c30637397ace5489eeb6e15d7d49
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Jan Engelhardt <jengelh@medozas.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Roman Mindalev <r000n@r000n.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 12:52 AM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> The performance benefit during operation is more important. The load
> time is fixable. The problem is probably generic to any set of rules,
> but could you post some info about your configuration (like the rule
> set), and the system configuration (# of cpu's, config etc).

I've about 150 different IPs like ...
        iptables -A block -s 155.161.173.128/26 -j ACCEPT
        iptables -A block -s 155.161.194.128/26 -j ACCEPT

So, to make it easy for testing, you can do a loop like this ...
        for((i = 1; i < 100; i++))
        do
                iptables -A block -s 10.0.0.$i -j ACCEPT
        done

I'm running ThinkPad X61. Dual core T9300, 2.5GHz, 4GB RAM, 256GB SSD.
No load as I was not running anything else, and X not running.

Thanks,
Jeff.
