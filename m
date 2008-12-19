Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYLSCHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYLSCHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 21:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYLSCGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 21:06:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:9598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYLSCGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 21:06:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=yMKvKKXAHM4h/R8zt+ilwYPmcM04ItIoaTMEUqiVetDcyLxEBmRM2Ii7u/7LTfA1U
	4WDcyCtmAosIIMtvLZWhQ==
MIME-Version: 1.0
In-Reply-To: <20081217140318.c6832440.akpm@linux-foundation.org>
References: <20081216113055.713856000@menage.corp.google.com>
	 <20081217140318.c6832440.akpm@linux-foundation.org>
Date: Thu, 18 Dec 2008 18:06:48 -0800
Message-ID: <6599ad830812181806h461ef9d6xb3b99da290ae521f@mail.gmail.com>
Subject: Re: [PATCH 0/3] CGroups: Hierarchy locking/refcount changes
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 2:03 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> cgroups-make-root_list-contains-active-hierarchies-only.patch
> cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
> cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
> cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
> cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
>
> it wasn't clear to me whether you still had issues with them, or
> whether updates were expected?

I think that with the fix patches they should be fine.

Paul
