Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0BRUcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:32:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0BRUcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:32:45 -0500
Message-ID: <4B7D9913.2090305@zytor.com>
Date: Thu, 18 Feb 2010 11:46:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Luca Barbieri <luca@luca-barbieri.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] x86: add support for multiple choice alternatives
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-2-git-send-email-luca@luca-barbieri.com> <4B7BE561.3070403@redhat.com>
In-Reply-To: <4B7BE561.3070403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 04:47 AM, Avi Kivity wrote:
> On 02/17/2010 01:42 PM, Luca Barbieri wrote:
>> This patch modifies the x86 alternative macros to allow more than one
>> alternative code sequence.
>>
> Suggest documenting the precedence of alternatives: if both feature1 and 
> feature2 are present, which newinstr is patched in?
> 

Looks like the last one in the sequence takes effect, which is
consistent with the operation of the single ALTERNATIVE() macro ...
anything else would be quite lunacy.

	-hpa
