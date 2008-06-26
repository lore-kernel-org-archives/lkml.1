Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbYFZSIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbYFZSIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759608AbYFZSHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:07:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:34609 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbYFZSHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hoPxe/rsy9C/9wYKcZi75pz1Yc2Xy9UuYeYixsWsv4ROUq+52p0Q1SXYYoMCmH0x0x
         KCMXw8oirjw5OF38291LzQO1J51jmN9GbWH+pLJUJLTDJbQFpZT2pARglzySFOQnuhS7
         ROxz3h6an9EWROphJbRTz/of3UrnejGNICIQI=
Message-ID: <86802c440806261107t6d2d1d66r4222017d9da29fbc@mail.gmail.com>
Date: Thu, 26 Jun 2008 11:07:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH] x86: rename setup.c to setup_percpu.c
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080626170918.GE1620@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806251037.11391.yhlu.kernel@gmail.com>
	 <20080626170918.GE1620@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:09 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 25.06.08 10:37:11, Yinghai Lu wrote:
>>
>>     some functions need to be moved to setup_numa.c
>>     after we merge setup32/64.c, some funcs need to be moved back to setup.c
>>
>>     Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Yinghai,
>
> x86: rename setup.c to setup_percpu.c:
>
> wouldn't it be sufficient to extend the affected functions with a
> *_percpu suffix?
>

we want to keep track of setup_32.c

YH
