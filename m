Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbZJZSX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbZJZSX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZJZSX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:23:58 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:33446 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZJZSX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cXJT7Tt6q1NSu7g7quDTi5E6Yn6D92DwsgBCNddfw88Loi9K0BNh/mDMhGzBCpi11j
         uWoQBg90gEFkfbu9iVJPvKCXGm6JBzO9wuC0FlKsAjukKqxPPaKfCDYV+7CujO4fI3oS
         MZTRGA5bIHJXWxrKIoz/YFL2l7w+LUvZCmhfc=
MIME-Version: 1.0
In-Reply-To: <4AD67C05.2030201@kernel.org>
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
	 <20091014151003.0ef42973.randy.dunlap@oracle.com>
	 <4AD67C05.2030201@kernel.org>
Date: Mon, 26 Oct 2009 11:24:00 -0700
X-Google-Sender-Auth: fd24d1b138814e3e
Message-ID: <12c511ca0910261124p64f2ad5emc88d00b9957482b3@mail.gmail.com>
Subject: Re: [PATCH -next] ia64/sn: fix percpu warnings
From: Tony Luck <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jes Sorensen <jes@sgi.com>,
       linux-ia64@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Acked-by: Tejun Heo <tj@kernel.org>
>
> Can this go through ia64 tree?  If not, I can route it through
> percpu#for-fixes.

It can ... but I'm getting a strange warning since I applied it:

  Building modules, stage 2.
  GZIP    arch/ia64/hp/sim/boot/vmlinux.gz
  MODPOST 198 modules
WARNING: "per_cpu____sn_cnodeid_to_nasid" [drivers/misc/sgi-xp/xpc.ko]
has no CRC!

Any idea what this means?

-Tony
