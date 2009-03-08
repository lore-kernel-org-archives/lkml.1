Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZCHS4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZCHS4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZCHS4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:56:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:58985 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZCHS4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VDzx+wwR4nSz2MEnjzIWqauCzO6OPNY8K9qSUzofhJDbi/bMSvy2CQH1VLhTe4Qxuj
         ulXASJivRwd8Gxeq2gzXWfBTQBiFggiOFXHNa41XHFtBvZQLllZ8Kzxs0dSGZOcq3vUG
         h/C3n/hRC+n04dY3pN4hgjslZp2aj25memrm8=
MIME-Version: 1.0
In-Reply-To: <COL116-W44867929BE0D134DE768B6DAA30@phx.gbl>
References: <COL116-W44867929BE0D134DE768B6DAA30@phx.gbl>
Date: Sun, 8 Mar 2009 14:56:34 -0400
X-Google-Sender-Auth: 929416dbd79328c9
Message-ID: <177c2b150903081156u687791d9ge076cb3cd07de42b@mail.gmail.com>
Subject: Re: doubt about path_walk() function
From: Mhayk Whandson <eu@mhayk.com.br>
To: Peter Hallberg <hallberg68@hotmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Peter.

On Sun, Mar 8, 2009 at 2:11 PM, Peter Hallberg <hallberg68@hotmail.com> wrote:
>
>> linuxshield/scan.c|998| error: implicit declaration of function ‘path_walk’
>> Searching in the internet, I can see that this function was removed in
>> one some kernel version, so how can I fix this problem ?
>
> It has been replaced with vfs_path_lookup, the fix for another fs looks like this:
> -    ret = path_walk(cachename, &nd);
> +    ret = vfs_path_lookup(nnpfsp->cachedir, nnpfsp->cacheroot,
> +                         cachename,
> +                         flags & O_CREAT ? LOOKUP_PARENT : 0,
> +                         &nd);
>
>
> _________________________________________________________________
> Dela foton på ett smidigt sätt med Windows Live™ Photos.
> http://www.microsoft.com/windows/windowslive/products/photos.aspx--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Mhayk Whandson
Linux User #413723
E-mail: eu@mhayk.com.br
