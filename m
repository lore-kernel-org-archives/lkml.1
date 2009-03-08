Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZCHRAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZCHRAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZCHRA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:00:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:62344 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZCHRA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=l0Zf2nWCIQ/Tmq5olYQ7Ij56gP+6dy64yTGN/aadnblCcNkXI91DtE+Ck5tHR9uBlT
         RkHtiOOa5ixfYS43046VEClvcv4ERvYUQk8dL+0KCN2w6zIGIXdIrDuWPx4+Zd45sbvY
         oYH8zMN3bQcpuF/cuyhiw4idp+QeORWUqjS/Q=
Message-ID: <49B3F9A5.4060506@gmail.com>
Date: Sun, 08 Mar 2009 18:00:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 1/2] x86_32: summit_32, use BAD_APICID
References: <20090224175518.GA15616@elte.hu> <1235508093-18063-1-git-send-email-jirislaby@gmail.com> <49A524D3.3090408@gmail.com> <20090225111002.GA15453@elte.hu> <49A71105.4050001@gmail.com> <20090228082120.GA11425@elte.hu>
In-Reply-To: <20090228082120.GA11425@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.2.2009 09:21, Ingo Molnar wrote:
>> I've sent 4 more patches, but there are still issues:
>> * es7000 + summit: I haven't solved calling with all bits set (only all
>> online is sufficient to trigger this). Some of the processors needn't be
>> on the same apic cluster. It will scream now (again -- it did before
>> adding the "optimisation"). Actually I don't know how to solve this. How
>> the caller would know the correct mask, ANDing with a apic->target_cpus
>> retval?

Anybody, please? This is not a theoretical issue, this is a real problem 
we hit...

