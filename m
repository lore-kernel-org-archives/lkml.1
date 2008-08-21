Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYHUTfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYHUTfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbYHUTfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:35:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49146 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbYHUTfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:35:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=at5T+iMHdplpU7iId8EG3tM5MoRevjUcgfUHMEfOH5lb/02NC1z718VlqwtMcJ3gn
	fMsCPISLGX3u9NkNg5mvw==
Message-ID: <b040c32a0808211235t24a35ce5q3fbc7a6c908b8c72@mail.gmail.com>
Date: Thu, 21 Aug 2008 12:35:31 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] fix NPTL thread iterator construct in cap_set_pg()
Cc: linux-kernel@vger.kernel.org, morgan@kernel.org
In-Reply-To: <20080821121827.45e44e4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0808150924h2b93529aj803e0b923e1f96f3@mail.gmail.com>
	 <20080821121827.45e44e4f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 12:18 PM, Andrew Morton wrote:
> cap_set_pg() gets deleted by the credentials patches in linux-next and
> afaict nothing replaced it.
>
> Does this patch actually fix anything?  If not, ignoring it would be a
> nice labour-saving device...

No, the patch was a result of code inspection.  There wasn't anything
that affected anyone.  If the function cap_set_pg() is destined for
deletion, yeah I agree there is no point of fixing it.

- Ken
