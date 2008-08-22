Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYHVH0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYHVH0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYHVH0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:26:42 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47865 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYHVH0l (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:26:41 -0400
Message-ID: <48AE6A27.9070103@de.ibm.com>
Date: Fri, 22 Aug 2008 09:26:31 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?UTF-8?B?Qk0gRGV1dHNjaGxhbmQgUmVzZWFyY2ggJiBEZXZlbG9wbWVudA==?=
 =?UTF-8?B?IEdtYkggLyBWb3JzaXR6ZW5kZXIgZGVzIEF1ZnNpY2h0c3JhdHM6IE1hcnRpbiA=?=
 =?UTF-8?B?SmV0dGVyLEdlc2Now6RmdHNmw7xocnVuZzogSGVyYmVydCBLaXJjaGVyLFNpdHo=?=
 =?UTF-8?B?IGRlciBHZXNlbGxzY2hhZnQ6IELDtmJsaW5nZW4gLyBSZWdpc3RlcmdlcmljaHQ=?=
 =?UTF-8?B?OiBBbXRzZ2VyaWNodCBTdHV0dGdhcnQsIEhSQiAyNDMyOTQ=?=
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
       carsteno@de.ibm.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
References: <48AD00F8.1030004@gmail.com> <200808211339.37187.arnd@arndb.de> <6934efce0808210755n1977e085o63b8b91e84575dc9@mail.gmail.com> <200808211706.37761.arnd@arndb.de> <6934efce0808210817h489bbeafyaf27217ca68bd31e@mail.gmail.com>
In-Reply-To: <6934efce0808210817h489bbeafyaf27217ca68bd31e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
>> The profiling code has certainly been useful to you during development,
>> and you should keep that code around for your own work on it,
>> but maybe you should not push that upstream, because regular users
>> are not going to need it.
> 
> Nope.  Profiling is absolutely fundamental to how AXFS works.  Read
> the [PATCH 00/10] thread again.
I agree, the profiling part is the sweet spot. Profiling should be in, 
probably even selectable at runtime as opposed to a config-switch. 
This way we could have it in enterprise distros that would'nt build 
another kernel image for this.
