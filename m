Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZGNO7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZGNO7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZGNO7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:59:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36739 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbZGNO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:59:51 -0400
Date: Tue, 14 Jul 2009 15:59:47 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency
	increase
Message-ID: <20090714145947.GA25171@srcf.ucam.org>
References: <200907081556.34682.czoccolo@gmail.com> <20090708161052.GA20951@srcf.ucam.org> <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com> <20090709233447.GA1770@ucw.cz> <4e5e476b0907140744qb2cf9cajc1c5dbbeba2ab66d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0907140744qb2cf9cajc1c5dbbeba2ab66d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 04:44:57PM +0200, Corrado Zoccolo wrote:

> The same program on an Atom doesn't show the same effect. It seems
> that Atoms scale also the FSB frequency together with core frequency.

I believe that this is true of all current Intel mobile chipsets - the 
lowest P-state will also reduce the FSB.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
