Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXC0DYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXC0DYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXC0DYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:24:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33586 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXC0DYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:24:15 -0400
Message-ID: <46088E59.6030304@hitachi.com>
Date: Tue, 27 Mar 2007 12:24:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: hch@infradead.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC][Patch 1/4] kprobe fast unregistration
References: <4603E7A4.50300@hitachi.com> <20070323180527.GA13728@bambi.jf.intel.com> <46073B5D.9090505@hitachi.com> <20070326181518.GA28384@bambi.jf.intel.com>
In-Reply-To: <20070326181518.GA28384@bambi.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anil,

Keshavamurthy, Anil S wrote:
> On Mon, Mar 26, 2007 at 12:17:49PM +0900, Masami Hiramatsu wrote:
>> Hi Christoph and Anil,
>>
>> Thank you for your comments.
>>
>> Christoph Hellwig wrote:
>>> Speeding up the unregistration is a very good idea, but this interface
>>> is rather horrible.  It's almost a receipe for users to get it wrong.
>> Keshavamurthy, Anil S wrote:
>>> I agree with Christop that the interface is horrible and error prone.
>> OK, I agree. I had chosen a confusable name.
> Keep in mind that the the sequence of unregistering a 
> probe should be same irrespecitve of whether user wants 
> to unregister a single probe or user want to 
> unregister more that one probe, i.e. you can not say 
> use this call (unregister_kprobe() ) for unregistering 
> a probe which is b.t.w slow and use this set of calls if you 
> have more than one kprobes to unregister for faster unregistration.

Would you mean that we should integrate unregistration interface?
Or, would you mean that you prefer "disable_kprobe()" since that
name provides another meaning?

Thanks,

-- 
Masami HIRAMATSU
Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
