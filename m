Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbXIDRfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbXIDRfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 13:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXIDRfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 13:35:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:21476 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbXIDRfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 13:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WkIYLwNT+7U23zqlRkYYuhrd07JR+WJGw2LHPRcGSbgZ4X+SBYF4Ttxp4wECkfvMl34na0OgVaFAcsZM8Yj9BFXHM1TyNixPjxrlnTuIq3PbJvrrMKfUcTjblxopNjiziMj6fW0524DeB8lqiFCpo7MF9nyekO/3jKDr0x70e9Q=
Message-ID: <379fb4870709041035p7f8d6fch6a683b54cbbbd81a@mail.gmail.com>
Date: Tue, 4 Sep 2007 19:35:00 +0200
From: "anon... anon.al" <anon.asdf@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: Race condition: calling remove_proc_entry in cleanup_module (module_exit) while someone's using procfile
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070904165637.GA1905@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <379fb4870709040939m2430be6ci57fd73f1f9abc6ef@mail.gmail.com>
	 <20070904165637.GA1905@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> For regular proc files, this is fixed in 2.6.23-rc1 and later.

Thanks!

I see you've been working on it:
fix-rmmod-read-write-races-in-proc-entries...
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/

((
older relevant posts:
http://groups.google.com/group/linux.kernel/browse_thread/thread/4c74bbea17727e6e/809c15bd0e6fa8f9?
http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/fb03e1a500fcb258/563a7f11acdec992?
))

Thanks, Albert
