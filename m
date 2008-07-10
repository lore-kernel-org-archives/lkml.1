Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbYGJSI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbYGJSI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbYGJSIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:08:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761254AbYGJSIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:08:39 -0400
Message-ID: <48764E8A.5010400@zytor.com>
Date: Thu, 10 Jul 2008 14:01:46 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487641D6.5060206@goop.org> <487649B2.3000405@sgi.com>
In-Reply-To: <487649B2.3000405@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> The discussion that followed was very emphatic that the size of the space should
> not be fixed, but instead be dynamically growable.  Since the offset needs to be
> fixed for each cpu, then virtual (I think) is the only way to go.  The use of a
> 2MB page just conserves map entries.  (Of course, if we just reserved 2MB in the
> first place it might not need to be virtual...?  But the concern was for systems
> with hundreds of (say) network interfaces using even more than 2MB.)
> 

I'm much more concerned about wasting an average of 1 MB of memory per CPU.

	-hpa
