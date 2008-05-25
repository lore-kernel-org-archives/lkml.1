Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbYEYTfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbYEYTfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYEYTfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:35:08 -0400
Received: from main.gmane.org ([80.91.229.2]:38176 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbYEYTfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:35:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Date: Sun, 25 May 2008 21:33:45 +0200
Message-ID: <m33ao689gm.fsf@ursa.amorsen.dk>
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <20080516132107.GA11304@csclub.uwaterloo.ca> <20080516161029.44ded734@core> <20080516173610.GA27126@csclub.uwaterloo.ca> <20080516191125.46f59ad6@core> <m31w42gf97.fsf@ursa.amorsen.dk> <1211727722.5913.63.camel@andromache>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:K4vVtu+avRRV1buS+7/z9unDtpQ=
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glen Turner <gdt@gdt.id.au> writes:

> On Fri, 2008-05-16 at 22:34 +0200, Benny Amorsen wrote:
>
>> Perhaps it would be possible to make most types of interrupts add
>> entropy, but not credit any entropy?
>
> You need to be certain that those sources are not able
> to be influenced by a hostile party, otherwise the entropy
> pool can be degraded to be less random over successive samples
> than its entropy score suggests.

Not if we don't credit any entropy. /dev/random is engineered to be
safe against getting non-random input, as long as that input isn't
credited with entropy. /dev/random is even world writable by default.


/Benny


