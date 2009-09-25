Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZIYDNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZIYDNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZIYDNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:13:43 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:55541 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZIYDNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:13:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LwVj/L08uvUPGUihRlW6m5zKn6rsMOU008KMBXEvGeIPyIaEfgjR91y++h11SQEigs
         94Gc0d9obDJKKyrynxNFob+OKphmYWwzd/oVnvDJGSCNLgBCmNrKlnT+bhNV3tgJO63C
         n7TPx3kwpNuO/6vBVwVYtu81hzP5Luu1cWTRw=
MIME-Version: 1.0
In-Reply-To: <20090925095105.b06d77f3.sfr@canb.auug.org.au>
References: <20090925095105.b06d77f3.sfr@canb.auug.org.au>
Date: Thu, 24 Sep 2009 22:13:46 -0500
Message-ID: <524f69650909242013r4d312204w9f8457c07db9dd24@mail.gmail.com>
Subject: Re: linux-next: cifs tree build failures
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs-client@lists.samba.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 6:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>
> fs/cifs/cifsfs.c: In function 'init_cifs':
> fs/cifs/cifsfs.c:1047: error: implicit declaration of function 'unregister_key_type'
>
> Caused by commit 3bc303c254335dbd7c7012cc1760b12f1d5514d3 ("cifs: convert
> oplock breaks to use slow_work facility (try #4)") exposing the call to
leinfo' was here
>
> I have reverted both those commits for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

These now are fixed in cifs-2.6.git.   In the same patch found a minor
locking problem which Jeff will fix tomorrow.


-- 
Thanks,

Steve
