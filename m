Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167Ab0ACXIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0ACXIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135Ab0ACXIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:08:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:32860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab0ACXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:08:06 -0500
Message-ID: <4B412341.2010002@kernel.org>
Date: Mon, 04 Jan 2010 08:07:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Hui Zhu <teawater@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       saeed bishara <saeed.bishara@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Nicolas Pitre <nico@fluxnic.net>, Ralf Baechle <ralf@linux-mips.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>,
       Chris Dearman <chris@mips.com>,
       Paul Gortmaker <Paul.Gortmaker@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Coly Li <coly.li@suse.de>
Subject: Re: [PATCH] stack2core: show stack message and convert it to core
 file 	when kernel die
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com>	<4B411F14.1040302@kernel.org> <20100103150134.5bdab023@infradead.org>
In-Reply-To: <20100103150134.5bdab023@infradead.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 08:01 AM, Arjan van de Ven wrote:
> On Mon, 04 Jan 2010 07:49:56 +0900
> Tejun Heo <tj@kernel.org> wrote:
>>
>> If implementing parsing of oops message in C is too awkward
>> (unsurprising at all), maybe implementing a converter in perl or
>> python is the easiest way so that it takes the oops message and puts
>> out well formatted input for the s2c program?
> 
> you mean like scripts/markup_oops.pl ?

Whichever one works but s2c wouldn't require symbol decoding.  Maybe
we can simply add an option to tell it to just parse the oops and
output it in machine friendly format.  Oh, also, the patch does add
new information the module load addresses.  We should be able to add
those to the oops message in a compact form.

Thanks.

-- 
tejun
