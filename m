Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYKSTNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYKSTNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYKSTNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:13:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:47742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYKSTNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:13:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=OKj+H6ZnpYAQ47LUCuXH+WzErsWZ/z/35wBw9NVl+Asz81d7EouJmydlcb5q7UklT
	yxff45H5kpb1a+eramiFg==
MIME-Version: 1.0
In-Reply-To: <cfd18e0f0811191110t792cc9a4i5869bee0fb3d759c@mail.gmail.com>
References: <4923230D.8090301@gmail.com>
	 <20081119000342.05b2de85.akpm@linux-foundation.org>
	 <cfd18e0f0811191110t792cc9a4i5869bee0fb3d759c@mail.gmail.com>
Date: Wed, 19 Nov 2008 14:13:06 -0500
Message-ID: <21c5ff280811191113p7fd4ec2aof34bd9eec1fbdea@mail.gmail.com>
Subject: Re: [patch] Fix type errors in inotify interfaces
From: Robert Love <rlove@google.com>
To: mtk.manpages@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, john@johnmccutchan.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 2:10 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> (Would be nice to see an Aacked-by from Robert or John on this patch.)

I hesitate because I haven't looked at glibc in ages to see what it
and other userland consumers are doing with inotify.

But my original analysis still seems correct, and whatever we do we
currently have inconsistencies, so this looks good to me.

Acked-by: Robert Love <rlove@rlove.org>

        Robert
