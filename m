Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbZHLFHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbZHLFHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 01:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZHLFHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 01:07:50 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64328 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZHLFHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 01:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=rM9cK3UVGaVmoXayLPWhQr+PlDfkWi2TpSmNYPn61yamigkeZUbnqXsw9zIpW1ffjA
         IjW6U10xbGsUIOvUivCStEArgMBX0W2wHF7NVRT/3r+9Tx274dwRmHc0vBD1fSjDiLs2
         MTuMA3qmElbrSwJJqBcFEy3a/656tKj9X2PM4=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <a45eb555ca7d9e23e5eb051e27f757ae70a6b0c5.1249999949.git.ebmunson@us.ibm.com>
References: <cover.1249999949.git.ebmunson@us.ibm.com>
	 <2154e5ac91c7acd5505c5fc6c55665980cbc1bf8.1249999949.git.ebmunson@us.ibm.com>
	 <a45eb555ca7d9e23e5eb051e27f757ae70a6b0c5.1249999949.git.ebmunson@us.ibm.com>
Date: Wed, 12 Aug 2009 07:07:48 +0200
Message-ID: <cfd18e0f0908112207y186d0aav6e0e55ce070778cf@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add MAP_LARGEPAGE for mmaping pseudo-anonymous huge 
	page regions
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Wed, Aug 12, 2009 at 12:13 AM, Eric B Munson<ebmunson@us.ibm.com> wrote:
> This patch adds a flag for mmap that will be used to request a huge
> page region that will look like anonymous memory to user space.  This
> is accomplished by using a file on the internal vfsmount.  MAP_LARGEPAGE
> is a modifier of MAP_ANONYMOUS and so must be specified with it.  The
> region will behave the same as a MAP_ANONYMOUS region using small pages.

Does this flag provide functionality analogous to shmget(SHM_HUGETLB)?
If so, would iot not make sense to name it similarly (i.e.,
MAP_HUGETLB)?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Watch my Linux system programming book progress to publication!
http://blog.man7.org/
