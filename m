Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXFRKbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXFRKbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXFRKb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:31:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:60750 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752924AbXFRKb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:31:26 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18Ei5EnVqMER6j4MsN3LhBCImJAAIiNH01dPldnC8
	EjCdGRMUB8h7ll
Date: Mon, 18 Jun 2007 12:32:14 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
       perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       levon@movementarian.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Separate performance counter reservation from nmi watchdog
Message-ID: <20070618103214.GA12045@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Stephane Eranian <eranian@hpl.hp.com>,
	oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
	perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
	levon@movementarian.org, akpm@linux-foundation.org
References: <20070612150246.GJ32163@frankl.hpl.hp.com> <20070612190730.GA6978@atjola.homenet> <20070613014136.GA2386@atjola.homenet> <20070613164632.GA8674@atjola.homenet> <20070618095238.GC20759@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618095238.GC20759@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.18 02:52:38 -0700, Stephane Eranian wrote:
> Hello Bjorn,
> 
> Sorry for the delay in my reponse.
> 
> > > From: Björn Steinbrink <B.Steinbrink@gmx.de>
> > > 
> > > Separate the performance counter reservation system from the nmi
> > > watchdog to allow usage of all performance counters even if the nmi
> > > watchdog is not used.
> > > 
> 
> I think it is a good idea to separate the counter allocator from NMI
> becuase as you said they are/will be use used by more than the NMI
> watchdog. Thus, I think you should drop the stirng nmi from the
> routines. I would also povide a separate header file for this allocator.

Rationale for both: This was already a (IMHO) rather huge patch for such
a bugfix so I didn't want to change even more code for the sake of
cleanup. I had planned to send a second patch for 2.6.23 that would do
the clean up, should have mentioned that (or included the second patch).

Will resend the patch later today, together with the cleanup patch.
Whoever applies it can then decide if the cleanup should go into 2.6.22
or 2.6.23.

Thanks,
Björn
