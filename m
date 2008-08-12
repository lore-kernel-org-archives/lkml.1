Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYHLV5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYHLV5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYHLV5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:57:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:26406 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYHLV5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hn3ahaHL0Jx2kaiVIVUsc97JqMUyTr5KLyV82ixJ8CCRnq8ZPyQDC4AKWJSH1LGt2N
         ga2vxDkfdrcGYH3Yuh5I6/Ughym9W6myxusSH6yaxFAJNhlp17xIfDFT6uu5CX2ZT0g7
         p81ZxCP0+V3Vth/K5UFQeQYrFgvt+3pmpgQMs=
Message-ID: <1ba2fa240808121457j33a83effo44110a0423d83f@mail.gmail.com>
Date: Wed, 13 Aug 2008 00:57:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: iwl + iomap + readl/writel
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48A20686.5080402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A1F734.7040801@gmail.com>
	 <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>
	 <48A20686.5080402@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 12:54 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 08/12/2008 11:49 PM, Tomas Winkler wrote:
>>
>> On Tue, Aug 12, 2008 at 11:48 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> I spotted that iwl drivers use readl method on an iomap space. IIRC some
>>> archs might return a tag instead of an address expected by readl/writel.
>>>
>>> I think you should either switch to ioread32/iowrite32 or to ioremap.
>>
>> Can you give me reading material  on this?
>
> No, google will (you can even feel lucky).

I didn't ask for obvious answers :)

Tomas
>
