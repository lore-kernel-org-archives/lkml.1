Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZHTClR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZHTClR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZHTClR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:41:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14930 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZHTClQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:41:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uFAAzagMe9jhYFAyTXFt3oBo4HRmwJqnsveLLpos1X/iujTX9Mx0LIdl/ekgh7Y8U
	SWKy9qaCRlyMVkQZ/gwAQ==
MIME-Version: 1.0
In-Reply-To: <4A8CB6F0.1020308@cn.fujitsu.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>
	 <4A8CB6F0.1020308@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 19:41:14 -0700
Message-ID: <6599ad830908191941g77db4e69ve46bc8623f77d97f@mail.gmail.com>
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 7:37 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> I come to realize the "procs" file will make it much harder to convert
> vmalloc/kmalloc with a different solution..
>

Why do you think that?

Paul
