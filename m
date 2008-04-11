Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYDKPsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYDKPsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759981AbYDKPsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:48:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:16736 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbYDKPsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HsISY+OrXpwu+UOEvlMxQ6W6R3QjrbKUkhabnSDZR2M3n06Si48tYAMV5ntYhEO6e5upbgEhx0wVXObGxl5msRVtX8ik3GxWq5uxGG5SqdwupM9ezq0a2lfUlbUyMtIJEQaOYIG/XIQMbXeho/49Oh9Mo3UluaTWajI2W9dxtU4=
Message-ID: <a44ae5cd0804110847q2ef30aa4r9f318d5e9443c123@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:47:42 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: =?WINDOWS-1252?Q?Re:_2.6.25-rc8-mm2_--_kernel/sched.c:8294:_error:_?= =?WINDOWS-1252?Q?unknown_field_=91read=5Fuint=92_specified_in_initializer?=
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a44ae5cd0804110829j7104ce43q21360078b7291032@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
	 <20080411135555.GA14342@elte.hu>
	 <a44ae5cd0804110829j7104ce43q21360078b7291032@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  I tried a "make mrproper" before compiling the 2.6.25-rc8-mm2 tree and it
>  still gave the same error.  This seems to be something specific to the latest
>  MM tree.

This seems to be the option that causes the error to trigger:

      CONFIG_CGROUP_SCHED=y

If I switch to USER_SCHED, the build continues.

       Miles
