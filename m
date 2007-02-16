Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbXBPXQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbXBPXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXBPXQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:16:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55746 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbXBPXQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:16:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=GZEhhIQkLBZf/+kP/S55n6ceeLsDLC60dLcHQ0uOTeM+BFwooIC3qIveNo1xLfXfz
	f/4mifqW8f1lvDpP9ZBvw==
Message-ID: <b040c32a0702161516md3d48a5kf3b75e5027c82b16@mail.gmail.com>
Date: Fri, 16 Feb 2007 15:16:49 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Olaf Hering" <olaf@aepfle.de>
Subject: Re: [PATCH] Remove stack hard limit on ia64
Cc: "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <20070216220654.GA11135@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216220654.GA11135@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Olaf Hering <olaf@aepfle.de> wrote:
> From: schwab@suse.de
>
> Un-Breaks pthreads, since Oct 2003.

why aren't you using /etc/security/limits.conf?
I think the stack limit can be set as big as 8TB on ia64 with default
16KB page size.

- Ken
