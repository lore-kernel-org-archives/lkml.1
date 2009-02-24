Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbZBXSG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbZBXSG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZBXSGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:06:17 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2339 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:06:17 -0500
Message-ID: <49A4365A.8080704@phoenixsoftware.de>
Date: Tue, 24 Feb 2009 19:03:06 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Stable Kernel <stable@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12766] Lots of smp_processor_id() in preemptible messages
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.-rC.vozoJB@chimera> <49A34777.3050809@goop.org>
In-Reply-To: <49A34777.3050809@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.348 () AWL,BAYES_50,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge schrieb:
>>
>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=12766
>> Subject        : Lots of smp_processor_id() in preemptible messages
>> Submitter    : Tilman Schmidt <t.schmidt@phoenixsoftware.de>
>> Date        : 2009-02-23 18:37 (1 days old)
>> References    : http://marc.info/?l=linux-kernel&m=123541536414019&w=4
> 
> Looks like stable needs to pick up 
> d85cf93da66977dbc645352be1b2084a659d8a0b.

I can confirm that commit d85cf93da66977dbc645352be1b2084a659d8a0b applied to 2.6.28.7 fixes this.

Thanks,
Tilman

