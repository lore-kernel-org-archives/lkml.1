Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZA0EDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZA0EDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 23:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZA0EDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 23:03:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:60948 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZA0EDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 23:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=G+fd+Oq0ENiByxkcgY+eSjcCD7Q8fX4BDX6v+BhbT5oVVXswdWyr2UDznHyAGJNXIh
         C+NZzQLCFhJ0sohTOZ21QgtolpCESdxq65AvPQQM+JrQQojWn1bXf5K28anyH58alHng
         wYYMPcukzegG3I2wus7OqMWt1LNFHKyY/nHFM=
Message-ID: <497E8778.9060503@gmail.com>
Date: Tue, 27 Jan 2009 13:03:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] x86-32: Fix __per_cpu_load relocation
References: <20090126103243.GA31307@elte.hu> <1232977445-11815-1-git-send-email-brgerst@gmail.com> <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>
In-Reply-To: <497E6B34.1020508@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing James Bottomley.)

Tejun Heo wrote:
> Ingo Molnar wrote:
>> * Brian Gerst <brgerst@gmail.com> wrote:
>>
>>> This patch fixes this error:
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> c0a4e07d 00e78001   R_386_32 c0ab0000  __per_cpu_load
>>>
>>> Now, __per_cpu_load is a section-relative symbol:
>>> c0aa4000 D __per_cpu_load
>>> c0aa4000 A __per_cpu_load_abs
>>>
>>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>> Applied to tip/core/percpu, thanks Brian!
> 
> Heh.. Thanks.  Sorry about lack of response.  It's lunar new year's
> day here and I'm off till tomorrow.  I'll start reviewing and
> integrating posted patches from tomorrow.

Well, I just had time to do it.  All the patches look fine to me.
Very nice cleanup.  The git tree is at the following URL.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=tj-percpu
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

The head commit is 2697fbd5faf19c84c17441b1752bdcbdcfd1248c.  James,
this patchset converts voyager to share generic x86 percpu code.  Can
you please review whether the change looks good for voyager?

Thanks.

-- 
tejun
