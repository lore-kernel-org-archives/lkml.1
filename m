Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYFDNe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYFDNe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYFDNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:34:19 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:18734 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYFDNeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=glQniq7pYH/MkJGrSpsPlSKus+kKybQE7sthosnas/bV6JshBWGntFAl21UiasRowy
         6uNFuFKS7abUxVNtR6i105oJdFx2godtrpOtAENJn36MCEpLC0PEMdMkDyrCnZ8c+KiA
         q0U/Ub4f8zjeU/H02ozOjrs0coQ0v90iHVONg=
Message-ID: <cfd18e0f0806040634p2c64d63es17aae9dfa9c2490c@mail.gmail.com>
Date: Wed, 4 Jun 2008 15:34:16 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch 0/4 v2] vfs: fix utimensat() non-conformances to spec
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       viro@zeniv.linux.org.uk, jamie@shareable.org, drepper@redhat.com,
       linux-fsdevel@vger.kernel.org, subrata@linux.vnet.ibm.com
In-Reply-To: <E1K3sxT-0000hy-9Z@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484694C1.7030603@gmail.com>
	 <E1K3sxT-0000hy-9Z@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 3:23 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> This patch series is a revised version of the patch series
>> that I sent yesterday to fix various utimensat()
>> non-conformances.  Patches 1 and 2 are unchanged (and were
>> Acked by Miklos); patches 3 and 4 are revised following
>> comments by Miklos.
>>
>> As requested I've split the original patch
>> ("utimensat() non-conformances and fixes [v4] (patch)";
>> http://article.gmane.org/gmane.linux.file-systems/24325 )
>> into four parts.  Ideally, these should be applied for
>> 2.6.26-rc, for the reasons outlined in my earlier mail
>> "utimensat() non-conformances and fixes [v4] (test results)",
>> http://article.gmane.org/gmane.linux.kernel/689411/ .
>>
>> The four patches can be applied independently, except that
>> patch 3 needs patch 2 to be applied first.
>
> ACK for all four patches.
>
> In patch 3/4 the indentation of that big "if" looks really horribly
> broken, but it will be cleaned out completely, so I won't complain...

Aargh -- true, I messed up the indentation!

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
