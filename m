Return-Path: <linux-kernel-owner+w=401wt.eu-S935218AbYBMVyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935218AbYBMVyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764788AbYBMVb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:59 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:52135 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYBMVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pPbFgzC+UagdD8qpHuq6v24KoSSo9iS7t5gth67BcTwIy5KKFcmSoa/+cKmMghj8a2jIaDOsNzhRw8Hk0jhIt9ebAgA9mS6leLGMvpC+sTPJHcpyySuLt2wEbOseBTZvR83ob03Ki7KW7G+TSxqsawEYEWKbh0aEUGCN5fBB+5Q=
Message-ID: <878847400802131331g622b5471o217ddbf4183cb6b8@mail.gmail.com>
Date: Wed, 13 Feb 2008 22:31:38 +0100
From: "Pierre PEIFFER" <peifferp@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH 2.6.24-mm1 1/8] (resend) IPC/semaphores: code factorisation
Cc: pierre.peiffer@bull.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080213200702.GE2144@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080212161340.200976067@bull.net>
	 <20080212162720.306787485@bull.net>
	 <20080213200702.GE2144@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 9:07 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Feb 12, 2008 at 05:13:41PM +0100, pierre.peiffer@bull.net wrote:
> > Trivial patch which adds some small locking functions and makes use of them
> > to factorize some part of the code and to make it cleaner.
>
> What's wrong with consolidation activity in general is that one need to
> follow tags many times to realise what on earth function really does.

Funny...
What's right with consolidation in general is that it avoids the
readers to read again and again the same piece of code and helps them
to focus on what the code really does.

-- 
Pierre
