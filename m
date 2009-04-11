Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbZDKEFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbZDKEFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 00:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbZDKEFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 00:05:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZDKEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 00:05:45 -0400
Message-ID: <49E016EB.3000800@zytor.com>
Date: Fri, 10 Apr 2009 21:04:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dag Bakke <dag@bakke.com>, linux-kernel@vger.kernel.org
Subject: Re: video (VGA) object-files unconditionally built/included?
References: <49DF2DCE.5050102@bakke.com> <20090410204308.155b7d65.akpm@linux-foundation.org>
In-Reply-To: <20090410204308.155b7d65.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> The video* objects sums up to 87kB. Can I get rid of that somehow? I am
>> using current git.
>>
>> This is my .config:
>> http://tapas.homeip.net/~dagb/tiny.config
> 
> I don't think those video things end up consuming memory after the
> kernel has booted?
> 

They aren't.  Plus, they don't add up to 87K -- more like 13K.

	-hpa
