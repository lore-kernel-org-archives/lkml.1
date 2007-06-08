Return-Path: <linux-kernel-owner+w=401wt.eu-S970326AbXFHSdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970326AbXFHSdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970384AbXFHSc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:32:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970863AbXFHSc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:32:57 -0400
Date: Fri, 8 Jun 2007 14:32:06 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Salyzyn <mark_salyzyn@adaptec.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mark Salyzyn <aacraid@adaptec.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 37/54] SCSI: aacraid: Correct sa platform support.
	(Was: [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1)
Message-ID: <20070608183206.GA20600@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
	stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Mark Salyzyn <mark_salyzyn@adaptec.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	Mark Salyzyn <aacraid@adaptec.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070608072127.352723000@sous-sol.org> <20070608072222.066056000@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608072222.066056000@sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:22:04AM -0700, Chris Wright wrote:
 > -stable review patch.  If anyone has any objections, please let us know.
 > ---------------------
 > 
 > From: Mark Salyzyn <mark_salyzyn@adaptec.com>
 > 
 > As discussed in the bugzilla outlined below, we have an sa based
 > (Mustang) RAID adapter on the system, a Dell PERC2/QC. Affected
 > controllers are HP NetRAID, Adaptec AAC-364, Dell PERC2/QC or Adaptec
 > 5400S. This problem  coincides with the introduction of the adapter_comm
 > and adapter_deliver platform functions (Message [PATCH 1/4] aacraid:
 > rework communication support code, January 23 2007, which initially
 > migrated to 2.6.21)
 > 
 > The panic occurs with an uninitialized adapter_deliver platform function
 > pointer. The enclosed patch, unmodified as tested by Rainer, solves the
 > problem.
 > 
 > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
 > Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
 > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
 > Signed-off-by: Chris Wright <chrisw@sous-sol.org>


drivers/scsi/aacraid/sa.c: In function 'aac_sa_init':
drivers/scsi/aacraid/sa.c:375: error: 'struct adapter_ops' has no member named 'adapter_restart'

	Dave

-- 
http://www.codemonkey.org.uk
