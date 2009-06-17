Return-Path: <linux-kernel-owner+w=401wt.eu-S1762040AbZFQAOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040AbZFQAOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbZFQAOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:14:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:47095 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbZFQAOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=e+hmrCUqpyFGLkL1cSoUHP3pSUCeTg/SIzVra5zG2daS9ezoiKcSUE/fecyMR9jSbI
         6XnRjx9A0cxdRVSCYnbVN59e/U2rY5W3KCHZtKbSRe2m/RgE4j1CxQ6pusvhvIulOTmq
         043I7DAkJKo1BGZVRNc/frCoZNFyMX6CuHY3o=
Message-ID: <4A38355B.7000909@gmail.com>
Date: Tue, 16 Jun 2009 18:14:19 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: braddo@tranceaddict.net
CC: linux-kernel@vger.kernel.org
Subject: Re: PAT support (or lack of) for Pentium 3 CPU's
References: <20090616080904.CCA17C3A@resin11.mta.everyone.net>
In-Reply-To: <20090616080904.CCA17C3A@resin11.mta.everyone.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 09:09 AM, Brad Allen wrote:
> It has come to my attention that PAT support has been disabled for P3 CPU's in kernel versions 2.6.30 and later due to a bug in the CPU.
>
> I have attempted to get the NVIDIA proprietary drivers working with these kernel versions and 3 different Pentium 3 motherboards, all have failed. The drivers seem to require PAT support in order to work correctly, each board has in fact produced a different error when using only MTRR.
>
> Can a kernel option be added to enable/disable PAT for P3 CPU's? Or is there any possible workaround for the bug?
>
> I'd be interested to hear from Radeon users running a 2.6.30 or later kernel.
>
> For anyone wondering why I still use such an old machine, I require ISA support.

What's the error(s) you are getting? PAT support was only added fairly 
recently, so obviously the driver should not require it for operation.
