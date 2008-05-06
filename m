Return-Path: <linux-kernel-owner+w=401wt.eu-S1765494AbYEFSoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765494AbYEFSoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbYEFSoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:44:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbYEFSon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:44:43 -0400
Message-ID: <4820A6DF.7010607@zytor.com>
Date: Tue, 06 May 2008 11:43:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fixed mtrr change WP to WB
References: <200805041823.57198.yhlu.kernel@gmail.com>	 <200805061038.58023.yhlu.kernel@gmail.com>	 <200805061041.40047.yhlu.kernel@gmail.com>	 <482099E6.5060208@zytor.com>	 <86802c440805061124w630bc987k71c3c290fdfde773@mail.gmail.com>	 <4820A401.1040105@zytor.com> <86802c440805061134y21fbb2a3s872c41c522b9f49f@mail.gmail.com>
In-Reply-To: <86802c440805061134y21fbb2a3s872c41c522b9f49f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>
>>  Obviously, if you have already modified a table, you should save a pointer
>> to it, and not rely on the kernel scanning later.
> 
> that modified mptable is for second kernel that is kexeced.
> 

Then you would have to add a method to pass it into the kernel if you 
want it to be generally useful.

	-hpa
