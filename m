Return-Path: <linux-kernel-owner+w=401wt.eu-S1161293AbXBZW3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161293AbXBZW3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161294AbXBZW3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:29:24 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56096 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161293AbXBZW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:29:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MSI entry unlinked before arch_teardown_msi_irq().
References: <m17iu6r4eg.fsf@ebiederm.dsl.xmission.com>
	<20070225.154637.70478886.davem@davemloft.net>
	<m18xelpyfg.fsf@ebiederm.dsl.xmission.com>
	<20070226.094747.59657430.davem@davemloft.net>
Date: Mon, 26 Feb 2007 15:29:17 -0700
In-Reply-To: <20070226.094747.59657430.davem@davemloft.net> (David Miller's
	message of "Mon, 26 Feb 2007 09:47:47 -0800 (PST)")
Message-ID: <m1irdoo8n6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Sun, 25 Feb 2007 17:14:43 -0700
>
>> David Miller <davem@davemloft.net> writes:
>> 
>> > From: ebiederm@xmission.com (Eric W. Biederman)
>> > Date: Sun, 25 Feb 2007 02:08:07 -0700
>> >
>> >> If that isn't the issue holler and I will look into it a little more.
>> >
>> > Talking in code is always more effective :-)
>> >
>> > This patch fixes the OOPS I was talking about:
>> 
>> Ok.  That is clearly reasonable.  Why do you need to traverse
>> the list here?  I just want to understand the requirements.
>
> The real problem turned out to be my using get_irq_data() instead
> of get_irq_msi() :-)
>
> Sorry for the noise.

No problem I helped cause the confusion...

Eric
