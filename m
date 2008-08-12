Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYHLVy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYHLVy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYHLVyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:54:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:22515 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYHLVyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=whyJAqc4wpr28RHWyoa5TbryolSwBNBxm1YNY2tpFq4RQch0q6U2MOciUSofQiY6Jr
         lhQIggkGCaTdGg/sVAYARxKx3Uvcve5aOKLNPYCAZf5q4vQK0A6asoQqB9lYjbdq5BeF
         987t4lwXKEE8f+Qdf4gSkPqHnp+uOtUocXYbs=
Message-ID: <48A20686.5080402@gmail.com>
Date: Tue, 12 Aug 2008 23:54:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iwl + iomap + readl/writel
References: <48A1F734.7040801@gmail.com> <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>
In-Reply-To: <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2008 11:49 PM, Tomas Winkler wrote:
> On Tue, Aug 12, 2008 at 11:48 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> Hi,
>>
>> I spotted that iwl drivers use readl method on an iomap space. IIRC some
>> archs might return a tag instead of an address expected by readl/writel.
>>
>> I think you should either switch to ioread32/iowrite32 or to ioremap.
> 
> Can you give me reading material  on this?

No, google will (you can even feel lucky).
