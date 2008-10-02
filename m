Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYJBTwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYJBTwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYJBTwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:52:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYJBTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:52:43 -0400
Message-ID: <48E525A1.5080509@zytor.com>
Date: Thu, 02 Oct 2008 12:48:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs
 to be set at compile time, V2
References: <20081001191945.4182d0be@redhat.com> <20081002081231.GC17695@elte.hu> <20081002153007.2e031232@redhat.com> <20081002194215.GA8078@elte.hu>
In-Reply-To: <20081002194215.GA8078@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> The default number of additional CPU IDs for hotplugging is determined 
>> by asking ACPI or mptables how many "disabled" CPUs there are in the 
>> system, but many systems get this wrong so that e.g. a uniprocessor 
>> machine gets an extra CPU allocated and never switches to single CPU 
>> mode.
>>
>> And sometimes CPU hotplugging is enabled only for suspend/hibernate 
>> anyway, so the additional CPU IDs are not wanted. Allow the number to 
>> be set to zero at compile time.
>>

Wouldn't this be better to have a runtime option?

	-hpa
