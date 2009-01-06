Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZAFMAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZAFMAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZAFMAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:00:30 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49425 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZAFMA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:00:29 -0500
Message-ID: <496347AC.5000203@s5r6.in-berlin.de>
Date: Tue, 06 Jan 2009 12:59:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: =?UTF-8?B?IkNoZW5nIFJlbnF1YW4gKOeoi+S7u+WFqCki?= <crquan@gmail.com>
CC: Alasdair G Kergon <agk@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <ak@suse.de>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [git pull] device-mapper patches for 2.6.29
References: <20081010125159.GK5098@agk.fab.redhat.com>	 <20090105191824.GP5098@agk.fab.redhat.com>	 <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>	 <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>	 <20090106032118.GC3512@agk.fab.redhat.com> <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
In-Reply-To: <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cheng Renquan (程任全) wrote:
> On Tue, Jan 6, 2009 at 11:21 AM, Alasdair G Kergon <agk@redhat.com> wrote:
>> On Tue, Jan 06, 2009 at 11:15:58AM +0800, Cheng Renquan (程任全) wrote:
>>> So now maybe we can add a null macro to module_refcount if
>>> CONFIG_MODULE_UNLOAD undefined?
>>
>> Do we even need the test at all?
> 
> So you mean add "#ifdef CONFIG_MODULE_UNLOAD ..." to dm-target.c? I
> can do that, but I really don't know a better solution without
> conditional compiling?

The fact that module_refcount may be undefined is an indicator that this
is not an API for general use.

Why are you wanting to peek into the reference count of a module?
Shouldn't you have everything covered by properly recounting all your
data objects?  (Preferably via the kref API.)
-- 
Stefan Richter
-=====-==--= ---= --==-
http://arcgraph.de/sr/
