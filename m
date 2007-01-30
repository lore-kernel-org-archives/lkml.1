Return-Path: <linux-kernel-owner+w=401wt.eu-S965637AbXA3RTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637AbXA3RTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXA3RTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:19:41 -0500
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:23755 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965637AbXA3RTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:19:40 -0500
X-YMail-OSG: eoXHKpgVM1klan2_M_kW_5T2dqiDQT04KRJsarhTS5NrWNDeA1DL0LtMWEADcLytFdMZ3Eud0QD7hJn5RPT6sI6eIq98Z9hVzSX1Sqtj_I6COFjMEY0-
X-RocketYMMF: rancidfat
Date: Tue, 30 Jan 2007 09:19:39 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] sysctl selinux: Don't look at table->de
To: Christoph Hellwig <hch@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, jmorris@namei.org
In-Reply-To: <20070130102508.GA10526@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <822578.32683.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 29, 2007 at 11:08:39AM -0800, Casey
> Schaufler wrote:
> > Alternativly you could move the SELinux specific
> > bits out of /proc/self/attr into an equivalent
> > /selinux/self/attr and avoid that /proc
> dependency.
> 
> Why?

To avoid the dependency and remove the issue.
Just a thought. Weigh the advantages and
disadvantages and do what seems right.

> procfs is essential for any kind of fullblown
> linux system,

Kids!

> and the selinux actually fits into the original
> procfs intention,

Yes, it does. It's a good use of /proc.

> unlike all the other junk we've added over the
> years.

You won't get any arguements from me there.


Casey Schaufler
casey@schaufler-ca.com
