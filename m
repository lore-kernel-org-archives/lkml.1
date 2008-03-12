Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYCLXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYCLXVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYCLXVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:21:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:59755 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYCLXVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NW4z+SA1qBqLA85U4ysMAMVc6Avzop5dAwlYdjjNK1qEouuoiRNDZAv0K5SDMSJCHwuZa9/By/AgO4l6zeKVhDrqjDESpWiPv04Vgw5O1jkRt2XuofhPfE+WW0IkCqsVeaCXZ6sDtn3JEcY+hmcO1P+qPciQFRDqRZgukB8Lums=
Message-ID: <86802c440803121621j3b9ec7e8nf7ae62b894eb85df@mail.gmail.com>
Date: Wed, 12 Mar 2008 16:21:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Cc: "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 6:01 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> [PATCH] mm: fix boundary checking in free_bootmem_core
>
>  so call it when numa is enabled, we don't know which node have that range.
>  and make it more robust.
>
>  try to trim it to get valid sidx, and eidx.
>
>  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>

Ingo,

this one need to be applied before
[PATCH] x86_64: reserve dma32 early for gart

YH
