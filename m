Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZAET7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZAET7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZAET7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:59:11 -0500
Received: from outbound-mail-125.bluehost.com ([67.222.38.25]:45798 "HELO
	outbound-mail-125.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751959AbZAET7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:59:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=PrwlR5jO4aIlsS+4BNCrVceRY02uan+iH15uNXhi+EyhftrdAriUELmab0AIBqkIUBnu8mOHTdu4lsIwHK4rR68Z7epVLoHkJWmlf+gRfPJj6zvFx4c+OSPBZziYSvKc;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
Date: Mon, 5 Jan 2009 11:59:08 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <200901051127.03598.jbarnes@virtuousgeek.org> <4962602D.4070502@sgi.com>
In-Reply-To: <4962602D.4070502@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051159.09278.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 5, 2009 11:31 am Mike Travis wrote:
> Jesse Barnes wrote:
> > On Sunday, January 4, 2009 5:18 am Mike Travis wrote:
> >> Impact: cleanup, reduce stack usage, use new cpumask API.
> >>
> >> Replace the local cpumask_t variable with a pointer to the
> >> const cpumask that needs to be printed.
> >>
> >> Signed-off-by: Mike Travis <travis@sgi.com>
> >> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> >
> > Can you resend these two against my linux-next branch?
> >
> > Thanks,
>
> Sure thing.  Would this be the latest .../sfr/linux-next.git master
> tree or would I need to select some other branch?

That would probably work, but my actual tree is at 
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git; the linux-
next branch is the one that I'll be sending to Linus soon.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

