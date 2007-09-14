Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbXINVxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbXINVxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbXINVxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:53:02 -0400
Received: from gw.goop.org ([64.81.55.164]:41922 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501AbXINVxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:53:00 -0400
Message-ID: <46EB02BA.6030909@goop.org>
Date: Fri, 14 Sep 2007 14:52:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com> <46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws> <46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws>
In-Reply-To: <46EB0136.6080105@codemonkey.ws>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Yeah, see, the initial goal was to make it possible to use the KVM
> paravirtualizations on other hypervisors.  However, I don't think this
> is really going to be possible in general so maybe it's better to just
> use leaf 0.  I'll let others chime in before sending a new patch.

Hm.  Obviously you can just define a signature for "kvm-compatible
hypercall interface" and make it common that way, but it gets tricky if
the hypervisor supports multiple hypercall interfaces, including the kvm
one.  Start the kvm leaves at 0x40001000 or something?

    J
