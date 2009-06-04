Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZFDJcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZFDJcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZFDJcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:32:33 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49883 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZFDJcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PRL7K2M7LJIqP2055VLHeUfnHYtY9Q0IO3U+5j8Yl2EpsYZnm2mGpIXeIJxoEiBPJ7
         bMhgd7JlUSUQWE9zR+Jywe2HWYM368F8UVs4E5ONahl/IdLozfoePz4ekz6GY/a+0sqS
         3NNmhZhjKf0RVXB/cWqNhKgKSheSyO1Ljn01M=
MIME-Version: 1.0
In-Reply-To: <E1MC99F-0004l5-JF@pomaz-ex.szeredi.hu>
References: <1119562997.1044731244033504415.JavaMail.root@mb1>
	 <E1MC99F-0004l5-JF@pomaz-ex.szeredi.hu>
Date: Thu, 4 Jun 2009 11:32:32 +0200
X-Google-Sender-Auth: f0dc7baec2f60cf4
Message-ID: <100d90a90906040232ofd2b5ebw8c8d5f677b13e840@mail.gmail.com>
Subject: Re: [PATCH] fuse: cache invalidation calls
From: Csaba Henk <csaba@gluster.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: avati@gluster.com, muirj@nortel.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dl-hacking@gluster.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 11:22 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, 3 Jun 2009, Anand Avati wrote:
>> I was wondering how the userland libfuse would be made aware of the
>> presence of these two notification features?
>
> Here's a patch against fuse CVS.  It's also from John Muir.

In fact, what we were meditating about is the lack of the
FUSE_KERNEL_MINOR_VERSION bump. Without that, how do the two parties
negotiate if the rev inval messages are understood? One of John's
patches in his patchset had it bumped though...

Csaba
