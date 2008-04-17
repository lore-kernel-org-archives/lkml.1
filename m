Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYDQXbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYDQXbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 19:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYDQXb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 19:31:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37078 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbYDQXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 19:31:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kenichi Ohmichi <oomichi@mxs.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>
References: <20080417010122.148289106@sous-sol.org>
	<20080417010334.951283202@sous-sol.org>
	<m17iewvnot.fsf@frodo.ebiederm.org>
	<20080417171616.GE17220@sequoia.sous-sol.org>
Date: Thu, 17 Apr 2008 16:31:12 -0700
In-Reply-To: <20080417171616.GE17220@sequoia.sous-sol.org> (Chris Wright's
	message of "Thu, 17 Apr 2008 10:16:16 -0700")
Message-ID: <m163ugawjj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: vmcoreinfo: add the symbol "phys_base"
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright <chrisw@sous-sol.org> writes:

> * Eric W. Biederman (ebiederm@xmission.com) wrote:
>> Chris Wright <chrisw@sous-sol.org> writes:
>> 
>> > -stable review patch.  If anyone has any objections, please let us know.
>> > ---------------------
>> 
>> This patch seems quite reasonable.  However as I read it, it is
>> a feature enhancement, that allows a user space tool to function
>> better.  Do we backport trivial features into stable now?
>
> Function better, meaning work reliably?  Sounds like a fix not a
> feature.

After you also upgrade user space, so it can use the additional
information allowing us to get better bug reports on kernels
built in an interesting fashion.

Essentially this patch widens our user space ABI very slightly.

I'm just being pedantic, and I don't oppose it.

Eric
