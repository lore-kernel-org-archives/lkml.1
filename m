Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbYGISen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbYGISen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYGISeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:34:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYGISef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:34:35 -0400
Message-ID: <487503C0.3010000@zytor.com>
Date: Wed, 09 Jul 2008 14:30:24 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org> <4874FEDF.90404@sgi.com>
In-Reply-To: <4874FEDF.90404@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> Did the suspected linker bug issue ever get resolved?
>> I don't believe so.  I think Mike is getting very early crashes
>> depending on some combination of gcc, linker and kernel config.  Or
>> something.
> 
> Yes and unfortunately since SGI does not do it's own compilers any
> more (they were MIPS compilers), there's no one here that really
> understands the internals of the compile tools.
> 

A bummer, too, since that compiler lives on as the Pathscale compiler...

	-hpa

