Return-Path: <linux-kernel-owner+w=401wt.eu-S1762419AbXHHSiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762419AbXHHSiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763132AbXHHSil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:38:41 -0400
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:25819 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759710AbXHHSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:38:39 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=XqxjyIFBhWVsaIabbfcz7AQbpxp9r9p7W8LRNIPgk8Ss9wyKvgn0q11zNYxnyTkuzDo+MyyBhfwfO1rMimgWjfiDOdR4b0/1R1C4PePXvF35al/Awl/mdSb2j/sRQjka;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,236,1183327200"; 
   d="scan'208";a="88120016"
Message-ID: <46BA0DA8.6000904@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 20:38:32 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com>	<20070807142928.GA18839@in.ibm.com>	<46B8AECA.7050908@fujitsu-siemens.com>	<m1ir7qg7kd.fsf@ebiederm.dsl.xmission.com>	<46B986D5.2010407@fujitsu-siemens.com>	<m1myx2dpcc.fsf@ebiederm.dsl.xmission.com>	<46B9FEC8.20004@fujitsu-siemens.com> <m1myx1c3lj.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1myx1c3lj.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

>>> irqpoll is working now.
>> Yes. I'd give a lot to know what went wrong when I tried that in April.
>> It'd have saved me many hours of work if I had discovered this workaround
>> before.
> 
> Yes that is odd.

Got it. At that time I was using "noirqdebug" because we had a FW problem that
caused a lot of misrouted IRQs. With "noirqdebug", "irqpoll" has no effect.
Bummer.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20409
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
