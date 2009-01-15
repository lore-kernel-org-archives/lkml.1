Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbZAOMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbZAOMSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZAOMSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:18:09 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:61595 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZAOMSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LXcZX9SVb0L62zylz1WYejn1heoh8TEy18QMjdyiCZk/5/Q4qWaP+azWGqwTsfbk6z
         /k0UQ+ntJ9tjpbj1pCeKnux7P78Ml+mpAP0mT8kMFV09FfstNaeC3QOiZ1Nm3vEXRgNg
         bjGPklTS6lPJI1vSPu+iw3ErXuwN8HS4yJBnE=
Date: Thu, 15 Jan 2009 12:18:01 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Chris Caputo <ccaputo@alt.net>
Cc: Denys Fedoryschenko <denys@visp.net.lb>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090115121801.GH5461@ff.dom.local>
References: <Pine.LNX.4.64.0901110438050.16453@nacho.alt.net> <20090114063909.GA4234@ff.dom.local> <200901141417.58667.denys@visp.net.lb> <1231937404.14825.4.camel@laptop> <Pine.LNX.4.64.0901141748300.17915@nacho.alt.net> <20090115065322.GA4190@ff.dom.local> <Pine.LNX.4.64.0901150724000.20461@nacho.alt.net> <20090115075450.GB4190@ff.dom.local> <20090115094530.GG4190@ff.dom.local> <Pine.LNX.4.64.0901151139440.20461@nacho.alt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901151139440.20461@nacho.alt.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 12:00:50PM +0000, Chris Caputo wrote:
...
> I wish I had a repro scenario in a non-production environment, so I could 
> help out further with this.  If I did, I would test without nmi_watchdog 
> while trying just 2.6.28 and Jarek's #4 patch.

I think this watchdog doesn't matter too much yet. Probably it's more
about hardware (smp, maybe kind of hw timer), and high traffic vs. htb
rules.

Jarek P.
