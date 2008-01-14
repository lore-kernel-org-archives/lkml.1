Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYANTIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYANTIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYANTIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:08:41 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51914 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750744AbYANTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:08:40 -0500
Message-ID: <478BB336.5000004@sgi.com>
Date: Mon, 14 Jan 2008 11:08:38 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] x86: Change NR_CPUS arrays in topology
References: <20080113183453.973425000@sgi.com> <20080113183454.815670000@sgi.com> <Pine.LNX.4.64.0801141925070.24893@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801141925070.24893@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 13 2008 10:34, travis@sgi.com wrote:
>> +++ b/include/asm-x86/cpu.h
>> @@ -7,7 +7,7 @@
>> #include <linux/nodemask.h>
>> #include <linux/percpu.h>
>>
>> -struct i386_cpu {
>> +struct x86_cpu {
>> 	struct cpu cpu;
>> };
>> extern int arch_register_cpu(int num);
> 
> Is not struct x86_cpu kinda redundant here if it only wraps around
> one member?

Looking at it, I think the x86 arch specific include file
is including the generic struct cpu (instead of say, a
different one)...?

Thanks,
Mike
