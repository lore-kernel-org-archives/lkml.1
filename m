Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYBNSFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYBNSFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYBNSFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:05:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbYBNSFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:05:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iN6Da5qEUAGHutF7hsvyN2mF6C4Z27/cENl4F6V92fDaZUS5gR+B1lCHJwDVnI0Kz
	SrsbA7doK49f+LKGwZhzw==
Message-ID: <6599ad830802141005i52236f7ak337ffffb915ea8ce@mail.gmail.com>
Date: Thu, 14 Feb 2008 10:05:04 -0800
From: "Paul Menage" <menage@google.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JPhvt-0002qE-Da@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
	 <6599ad830802140813n71b56dccud33e19642a0d7647@mail.gmail.com>
	 <E1JPhvt-0002qE-Da@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 9:31 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>  I deliberately not used the MS_* flags, which is currently a messy mix
>  of things with totally different meanings.
>
>  Does this solve all the issues?

We should add a size parameter either in the mount_params or as a
final argument, for future extensibility.

And we might as well include MNT_READONLY in the API on the assumption
that per-mount readonly will be available soon.

Paul
