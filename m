Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZESMNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZESMNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZESMNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:13:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43093 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbZESMNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:13:11 -0400
Message-ID: <4A12A05C.6050004@redhat.com>
Date: Tue, 19 May 2009 14:04:44 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <JBeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org>	<4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45>	<m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org>	<20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org>	<20090519095918.GA11790@elte.hu>	<4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu>
In-Reply-To: <20090519110837.GA10548@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/09 13:08, Ingo Molnar wrote:
> Or, alternatively, the hypervisor can expose its own administrative
> interface to manage MTRRs.

Guess what?  Xen does exactly that.  And the xen mtrr_ops implementation 
uses that interface ...

cheers,
   Gerd
