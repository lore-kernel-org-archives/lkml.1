Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYEWPdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYEWPdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYEWPc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:32:59 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:52612 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752349AbYEWPc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:32:58 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: early dump pci conf space v2
Date: Fri, 23 May 2008 08:32:41 -0700
User-Agent: KMail/1.9.9
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <20080523053822.GA28835@colo.lackof.org> <86802c440805222338w3c8e946eree2d090ce12609e@mail.gmail.com>
In-Reply-To: <86802c440805222338w3c8e946eree2d090ce12609e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805230832.42047.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 22, 2008 11:38 pm Yinghai Lu wrote:
> > Please call this "pci_early_dump" (I prefer with underscores but don't
> > care). Don't want it confused with kernel dumps (LKCD) or any other
> > general debugging tools.
>
> so you want pci_early_dump instead of pci=earlydump?
> or pci=early_dump?

Or early_config_dump, I don't have a strong preference (but Grant's right that 
a pci_ prefix should be on there somewhere, either pci= or pci_).

Can you send me a replacement for the patch that added it once you come up 
with something?

Thanks,
Jesse
