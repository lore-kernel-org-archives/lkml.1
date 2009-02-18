Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZBRJ4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZBRJ4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZBRJ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:56:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:20758 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZBRJ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:56:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JdgKvu7iffCSu4pAmWm+4dOT9d39G/ZJvMZL5Bo+qCrONQiSR8/MGRI7YkDHdlQQeS
         SxH/M/CY3BJ1+9+5H9N67+B0Q1b4aifHSRGXBVQnoPwkHNyl/qHG3aFPrM+KOC20KsOT
         AVCT8BHaC4bAtIP/NYzOoMsouQvexRpgZVY5g=
MIME-Version: 1.0
In-Reply-To: <4995F27E.3070401@redhat.com>
References: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com>
	 <498C7671.1050309@redhat.com>
	 <a4423d670902061004i424817e1vd699a61e335f010a@mail.gmail.com>
	 <498C9876.3060208@redhat.com>
	 <a4423d670902090401k716d054eo25640aa2207beca7@mail.gmail.com>
	 <4995F27E.3070401@redhat.com>
Date: Wed, 18 Feb 2009 12:56:33 +0300
Message-ID: <a4423d670902180156yd293319na51f91c6651e076c@mail.gmail.com>
Subject: Re: next-20090206: deadlock on ext4
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/14 Eric Sandeen <sandeen@redhat.com>:
> Alexander Beregalov wrote:
>
>> I have reproduced it with 2.6.29-rc4.
>> Loop file was on XFS.
>> I can not reproduce it on ext4 on raw device.
>> Let me know if I can do anything else to help resolving it.
>>
> Can you try this patch from Aneesh?  Works for me...
>

Yes, it works, I can not reproduce the bug on
2.6.29-rc5-00122-g5955c7a which contains 2acf2c261b82
"ext4: Implement range_cyclic in ext4_da_writepages instead of
write_cache_pages"

Thanks
