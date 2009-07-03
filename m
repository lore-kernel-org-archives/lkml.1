Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZGCA0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZGCA0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZGCA0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:26:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3199 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbZGCA0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:26:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KmNvh8ZdOsF4UvSVWFDsvBuyojUuWfqt99paqXcN0pZXmjTMmP+8RfN4klMgkLJIR
	rNaeaXqD6WoVnWMj8WyHw==
MIME-Version: 1.0
In-Reply-To: <6599ad830907021722x7b012991i1eca056bc72c010c@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232625.3969.54444.stgit@menage.mtv.corp.google.com>
	 <20090702165413.f4a21471.akpm@linux-foundation.org>
	 <6599ad830907021722x7b012991i1eca056bc72c010c@mail.gmail.com>
Date: Thu, 2 Jul 2009 17:26:42 -0700
Message-ID: <6599ad830907021726s16264cf3o1e8b4e20d00b50c8@mail.gmail.com>
Subject: Re: [PATCH 2/2] Ensures correct concurrent opening/reading of 
	pidlists across pid namespaces
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       bblum@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 5:22 PM, Paul Menage<menage@google.com> wrote:
>
> So I'm not sure how "stg mail" managed to lose that.
>

Ah - I was missing a

%(fromauth)s

tag in my stgit patchmail template so it wasn't mentioning the real
"From" author. Now fixed for next time I send.

Paul
