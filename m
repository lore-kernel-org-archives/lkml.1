Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYBZI6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYBZI6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbYBZI6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:58:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYBZI6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:58:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QOgIbZZZCd/8iofbbDFKOcMAqhOgyZK4mPenWxZ/uRgnnF9OIXDJZnwUthRovZqrn
	U3E0SSnEtjF6VmbSxJ41Q==
Message-ID: <6599ad830802260058m28d8f46djc83f47e19e2946a7@mail.gmail.com>
Date: Tue, 26 Feb 2008 00:58:06 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Memory Resource Controller Add Boot Option
Cc: balbir@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47C38127.2000109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080225115509.23920.66231.sendpatchset@localhost.localdomain>
	 <20080225115550.23920.43199.sendpatchset@localhost.localdomain>
	 <6599ad830802250816m1f83dbeekbe919a60d4b51157@mail.gmail.com>
	 <47C2F86A.9010709@linux.vnet.ibm.com>
	 <6599ad830802250932s5eaa3bcchbfc49fe0e76d3f7d@mail.gmail.com>
	 <47C2FCC1.7090203@linux.vnet.ibm.com> <47C30EDC.4060005@google.com>
	 <47C38127.2000109@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 7:01 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>  >
>  > - foo doesn't show up in /proc/cgroups
>
>  Or we can print out the disable flag, maybe this will be better?
>  Because we can distinguish from disabled and not compiled in from
>
> /proc/cgroups.

Certainly possible, if people felt it was useful.

>
>  > - foo isn't auto-mounted if you mount all cgroups in a single hierarchy
>  > - foo isn't visible as an individually mountable subsystem
>
>  You mentioned in a previous mail if we mount a disabled subsystem we
>  will get an error. Here we just ignore the mount option. Which makes
>  more sense ?
>

No, we don't ignore the mount option - we give an error since it
doesn't refer to a valid subsystem. (And in the first case there is no
mount option).

Paul
