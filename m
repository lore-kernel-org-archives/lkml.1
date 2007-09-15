Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbXIOExv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbXIOExv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 00:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXIOExp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 00:53:45 -0400
Received: from gw.goop.org ([64.81.55.164]:52043 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXIOExo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 00:53:44 -0400
Message-ID: <46EB6556.5020506@goop.org>
Date: Fri, 14 Sep 2007 21:53:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com> <46EB2716.1070908@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com>
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> The hypervisor detection machanism is generic, and the signature
> returned is implentation specific. Having a list of all hypervisor
> signatures sounds fine to me as we are detecting vendor-specific
> processor(s) in the native. And I don't expect the list is large. 
>
>   

I'm confused about what you're proposing.  I was thinking that a kernel
looking for the generic hypervisor interface would check for a specific
signature at some cpuid leaf, and then go about using it from there.  If
not, how does is it supposed to detect the generic hypervisor interface?

    J
