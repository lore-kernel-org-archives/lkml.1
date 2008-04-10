Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbYDJGv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbYDJGv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYDJGvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:51:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:28526 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYDJGvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tj2N/Afc09Xp71W5pFXEO4PQMWw6wa0GKMKhgiaP/5KSsnVi6KY+3JFXQMc76d1+l8tDz+DQrshravRvqViwDoMWNqZqe1N+ZRVNBJqtFih9MtbIhp2e5WA58djwN21MbFhp1NONS633jPxrvTbn+2g9n2yDxk/pa5M7a1Vlfo8=
Message-ID: <ac8af0be0804092351g5388f75fr53cd4cf0774e0fd9@mail.gmail.com>
Date: Thu, 10 Apr 2008 14:51:42 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Does Linux have plan to support memory hole remapping?
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       mingo@elte.hu, ak@suse.de
In-Reply-To: <20080409091307.GG19010@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	 <87iqyro3rc.fsf@basil.nowhere.org>
	 <ac8af0be0804090204t79beaca2qe077a28fc4a515ad@mail.gmail.com>
	 <20080409091307.GG19010@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is some loss of memory before MemTotal, both from the BIOS
> (SMM, Frame Buffer for integrated graphics etc.) and from the kernel
> (mem_map which costs a few percent and some other data structures
> which are allocated early)
>
> I covered this in detail in http://halobates.de/memorywaste.pdf
>

I read your paper, which is very helpful for us to understand the
memory usage in Linux kernel.
And I have a question about output of slabtop:
 Active / Total Objects (% used)    : 730986 / 750823 (97.4%)
 Active / Total Slabs (% used)      : 46124 / 46125 (100.0%)
 Active / Total Caches (% used)     : 99 / 149 (66.4%)
 Active / Total Size (% used)       : 169383.63K / 172467.11K (98.2%)

Could you please elaborate on Active / Total Caches? The meaning of
other lines are obvious to me.

Thanks,
Forrest
