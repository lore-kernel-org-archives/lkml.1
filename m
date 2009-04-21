Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZDUSZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZDUSZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZDUSZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:25:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:14285 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZDUSZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=naRM6xrO9arV/et5H/SZkVzKpm996q4H5kN/M764B7o8P/Le4ST4c5r6TiJrIsf1p3
         LZcaTrwZjgFDqhwprIN5r5xEf+v68cSZ9F28ESKOd/F8qXD/k8FnIvi/dfUJjRN+mQ7m
         c+reHAdaIW2/SoO0JVNH84SlHF/mjmTkmKUUs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0904211034550.19969@qirst.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
	 <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
	 <alpine.DEB.1.10.0904211034550.19969@qirst.com>
Date: Tue, 21 Apr 2009 21:25:31 +0300
X-Google-Sender-Auth: c6658cb7204e3672
Message-ID: <84144f020904211125v68b98df4ke1c04bc29df65fda@mail.gmail.com>
Subject: Re: linux-next ia64 build problems in slqb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, randy.dunlap_ocs10g@oracle.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, iwamatsu.nobuhiro@renesas.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 1:08 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> > The ia64 "allnoconfig" build ends up with the (possibly dubious) combination
>> > of .config options:
>> >
>> >        CONFIG_SMP=n
>> >        CONFIG_NUMA=y
>>
>> Yeah, I don't think the combination makes much sense and x86 doesn't
>> allow it. Can we fix that in ia64 Kconfig? That said, this seems to
>> come up with every architecture except x86, so if someone is kind
>> enough to send me a tested fix for slqb, I'll just go ahead and apply
>> it.

On Tue, Apr 21, 2009 at 5:35 PM, Christoph Lameter <cl@linux.com> wrote:
> Tony runs tests with this configuration. This is an established
> configuration and has been historically supported.

Interesting. What exactly is an UP NUMA machine? Anyway, I'm more than
happy to apply a tested patch to fix up SLQB. Nick?
