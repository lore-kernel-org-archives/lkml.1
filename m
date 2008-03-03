Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYCCPTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYCCPTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYCCPTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:19:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:5764 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYCCPTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YiIHWFP4C08jgu/9yEc/7HSV4S8grGwZd+zs9otkJJLRKLOaLPYNo8V8nyeYt1DYgWqbOgQ8tB23ut9Nbwn1K4g7F9DFdIBSOPGS0RRcO55yAf4pKxMFMGg/hm7R7hASC3OHvWac8aX9UK0Ujza+HOlwBzT8TyqJU6JtTbGgqWY=
Message-ID: <3d8471ca0803030719x418f9997tc428344e659a6c90@mail.gmail.com>
Date: Mon, 3 Mar 2008 16:19:22 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] chroot= as a new kernel parameter
Cc: "Pawel Plociennik" <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080303141203.GB12606@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803011409.59526.paplociennik@gmail.com>
	 <200803021859.30473.paplociennik@gmail.com>
	 <3d8471ca0803021005o46f99282l77d412306877607a@mail.gmail.com>
	 <200803022009.04028.paplociennik@gmail.com>
	 <20080303141203.GB12606@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 3:12 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sun 2008-03-02 20:09:03, Pawel Plociennik wrote:
>  > so I thing that my patch is *unnecessary* now :-(
>
>  Actually I disagree here. This means that if distro in / breaks, you
>  will not be able to boot in ditstro in /foo any more :-(.

For this case, you can boot with something like:

init=/working_distro/lib/ld-linux.so.2 --library-path
/working_distro/lib  /working_distro/usr/sbin/chroot /working_distro/
/sbin/init

And that's actually how you should setup your grub.conf to avoid
depending on the distro in /.

-- 
Guillaume
