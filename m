Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbYFDMCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbYFDMCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYFDMBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:01:51 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:55647 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYFDMBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oaIZFiWQtQCEQPhAnT/aQv8Fa/fUOyYj4FIXIxICjEY6lMvOs0EO/hxOH/YJ7MOaXD
         siPOyojEThGkoP8g5jCMXtk1gjjmBOAjBHPkX88vn9P0qvAMGeWBeYdckXZZEHSaF09v
         H0cg948WVppb0aDaaVq9tQoK7j1MXowS0AcWQ=
Message-ID: <cfd18e0f0806040501i43f4faeagd44599efea0463c6@mail.gmail.com>
Date: Wed, 4 Jun 2008 14:01:48 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [parch 1/4] vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT or UTIME_NOW
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       viro@zeniv.linux.org.uk, jamie@shareable.org, drepper@redhat.com,
       linux-fsdevel@vger.kernel.org, subrata@linux.vnet.ibm.com
In-Reply-To: <E1K3kbK-0007c4-PF@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4845C4B4.8040706@gmail.com>
	 <E1K3kbK-0007c4-PF@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 6:27 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> The POSIX.1 draft spec for utimensat() says that if a times[n].tv_nsec
>> field is UTIME_OMIT or UTIME_NOW, then the value in the corresponding
>> tv_sec field is ignored.  However the current Linux implementation
>> requires the tv_sec value to be zero (or the EINVAL error results).
>> This requirement should be removed.
>>
>> CC: Miklos Szeredi <miklos@szeredi.hu>
>> CC: Al Viro <viro@zeniv.linux.org.uk>
>> CC: Ulrich Drepper <drepper@redhat.com>
>> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
> Would it be possible to quote the relevant parts of the draft?

Will do, for the next revision of this patch series.

> Otherwise
>
> Acked-by: Miklos Szeredi <mszeredi@suse.cz>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
