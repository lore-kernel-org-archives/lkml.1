Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZIQXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZIQXel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZIQXej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:34:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZIQXej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:34:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jCp04C4QN8ZEVo6JYCJ1nbQb8XjTqvhgoxDKMvJQgU11os0SaUZliKm5K0T1ypDUJ
	IAwn+oxl4At9XRMVj2muA==
MIME-Version: 1.0
In-Reply-To: <20090915184237.13160e2a.akpm@linux-foundation.org>
References: <6599ad830909151740n2affe0daw27618ccae9c737d6@mail.gmail.com>
	 <20090915184237.13160e2a.akpm@linux-foundation.org>
Date: Thu, 17 Sep 2009 16:34:37 -0700
Message-ID: <6599ad830909171634j64038843k8570b5200db5f2e7@mail.gmail.com>
Subject: Re: 2.6.32 -mm merge plans (cgroups)
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 6:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> What would happen if we merged it as-is?  Can we be confident that the
> resulting bugs won't impact others

Yes, I'm fairly confident that the race/bug wouldn't affect anyone who
didn't write to a cgroup.procs file.

> and that we can get them all fixed
> up reasonably promptly?

No, that's not clear yet.

Paul
