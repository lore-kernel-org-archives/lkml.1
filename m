Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbYEPUfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbYEPUfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYEPUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:35:07 -0400
Received: from main.gmane.org ([80.91.229.2]:58755 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYEPUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:35:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Date: Fri, 16 May 2008 22:34:12 +0200
Message-ID: <m31w42gf97.fsf@ursa.amorsen.dk>
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <20080516132107.GA11304@csclub.uwaterloo.ca> <20080516161029.44ded734@core> <20080516173610.GA27126@csclub.uwaterloo.ca> <20080516191125.46f59ad6@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:MJyFgT8NDmtY0aAlfNfJ9j1Fz+o=
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> If they don't need that level of security they can use /dev/urandom.
> Piping network randomness into /dev/urandom is probably quite sensible
> but not into /dev/random.

Perhaps it would be possible to make most types of interrupts add
entropy, but not credit any entropy?


/Benny


