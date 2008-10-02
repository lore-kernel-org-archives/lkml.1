Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYJBQsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYJBQsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYJBQrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:47:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58846 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYJBQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:47:54 -0400
Message-ID: <48E4FA53.7050401@zytor.com>
Date: Thu, 02 Oct 2008 09:44:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Dean Nelson <dcn@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH] x86, UV: add uv_setup_irq() and uv_teardown_irq() functions
References: <20081001114415.GA3281@sgi.com> <86802c440810020919p4391cbebva0eaa5591e7915be@mail.gmail.com>
In-Reply-To: <86802c440810020919p4391cbebva0eaa5591e7915be@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> +
>> +static struct irq_chip uv_irq_chip = {
>> +       .name           = "UV_MSI",
> 
> anything to do with MSI?
> 

Not really.  It probably should be called "UV-CORE" or something like that.

	-hpa
