Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZC0RmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZC0RmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZC0RmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:42:11 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42808 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZC0RmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=j17TDiRwPQ8R7upfJzLeDQwCQQsgKK71ru1VzBy7rvrafQM3LrZ6Ev/l3SzQwcDh6C
         a+ltDNgIuOYZ/xp+UAr18z85Xe5nIO/wTi5vV6EN71QNKkCE9CEgyXuEJSLiK0BHg4U5
         NYvFfncimiOD/8h/z+tXfSbxrGMvwfQWiyj9o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for March 27 (longhaul build error)
Date: Fri, 27 Mar 2009 18:42:35 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-next-20090320; KDE/4.2.1; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>
References: <20090327231924.4e4168c5.sfr@canb.auug.org.au>
In-Reply-To: <20090327231924.4e4168c5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903271842.37665.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 27 March 2009, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090326:

I hit the following build error using OpenSUSE's kernel config:

arch/x86/kernel/cpu/cpufreq/longhaul.c: In function ‘longhaul_setstate’:
arch/x86/kernel/cpu/cpufreq/longhaul.c:308: error: implicit declaration of function ‘acpi_set_register’
make[1]: *** [arch/x86/kernel/cpu/cpufreq/longhaul.o] Error 1
make: *** [arch/x86/kernel/cpu/cpufreq/longhaul.o] Error 2

Len, it seems like the following patch managed to slip through the cracks:

	http://patchwork.kernel.org/patch/12715/

Thanks,
Bart
