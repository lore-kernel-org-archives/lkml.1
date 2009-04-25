Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZDYHGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZDYHGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 03:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZDYHG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 03:06:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48122 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbZDYHG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 03:06:28 -0400
To: David Miller <davem@davemloft.net>
Cc: cl@linux.com, linux-kernel@vger.kernel.org
References: <20090422085828.GA16917@elte.hu>
	<alpine.DEB.1.10.0904241429450.19686@qirst.com>
	<20090424.222952.83381016.davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 25 Apr 2009 00:06:22 -0700
In-Reply-To: <20090424.222952.83381016.davem@davemloft.net> (David Miller's message of "Fri\, 24 Apr 2009 22\:29\:52 -0700 \(PDT\)")
Message-ID: <m163gtxle9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: davem@davemloft.net, linux-kernel@vger.kernel.org, cl@linux.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3078]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [rfc] built-in native compiler for Linux?
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Christoph Lameter <cl@linux.com>
> Date: Fri, 24 Apr 2009 14:34:49 -0400 (EDT)
>
>> On Wed, 22 Apr 2009, Ingo Molnar wrote:
>> 
>>> What i think makes sense is to build a _new_ precompiler / compiler
>>> / assembler / linker combo for Linux, from scratch, hosted in the
>>> kernel proper.
>>>
>>> A good technical basis for that would be Sparse, and it could start
>>> by acting as a drop-in replacement for CPP and it could feed its
>>> output to GCC with little changes. Sparse is small, has a very tidy
>>> code base and is already useful today as an extended static source
>>> code checker.
>> 
>> A new preprocessor would be great. If we can make sparse do what CPP does
>> now then lets go for it.
>
> It's just too bad that we'll lose the performance gained from the
> fact that GCC's CPP is linked into the C compiler binary and thus
> doesn't have to transfer it's result over a pipe or anything like
> that.
>
> I really think this whole idea isn't a very smart one.  I would
> rather have whoever would be working on a sparse backend instead
> be working on kernel improvements.
>
> I also think people underestimate how much work this would be.

>From what little I have seen of this conversation I would have
to agree.  I have written my own C compiler in roughly the manner
proposed in the original email and I would be happy to discuss how
much work it really is if someone is interested.

If this was about teaching sparse to run lockdep at compile time, or
generally about making the kernel compilation much faster and able to
catch many more bugs there might be a point where the effort is worth
the investment.

Eric
