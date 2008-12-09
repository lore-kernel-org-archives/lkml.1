Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYLILbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYLILbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYLILbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:31:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39991 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYLILba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:31:30 -0500
To: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
Cc: "Andi Kleen" <ak@linux.intel.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
From: Andi Kleen <andi@firstfloor.org>
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	<12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	<20081207141337.588aede5@infradead.org>
	<12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	<493CCFE4.2080802@jp.fujitsu.com>
	<12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	<493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
	<493CF65B.30408@jp.fujitsu.com> <493D0D42.2090203@linux.intel.com>
	<12bfabe40812082154y188e9167vd37589b758d9868d@mail.gmail.com>
Date: Tue, 09 Dec 2008 12:31:47 +0100
In-Reply-To: <12bfabe40812082154y188e9167vd37589b758d9868d@mail.gmail.com> (Giangiacomo Mariotti's message of "Tue, 9 Dec 2008 06:54:26 +0100")
Message-ID: <871vwheg9o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Giangiacomo Mariotti" <gg.mariotti@gmail.com> writes:

> On Mon, Dec 8, 2008 at 1:04 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> Also it might be really some problem with this particular CPU.
>>
>> -Andi
>>
> It might be interesting to notice that booting a different distro and

Does that different distro have machine checks enabled, was
mcelog installed and did you wait 5 minutes for mcelog's cronjob to run? 

> then doing a kexec from that into my 2.6.27.8 make the mce log
> disappear.

Yes of course if it comes out of BIOS POST then there won't be another
one on kexec.

-Andi

-- 
ak@linux.intel.com
