Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXHUGEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXHUGEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbXHUGEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:04:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:53977 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130AbXHUGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NviepWFXmZcCcZnVJcrsJXzAHfn3VM+sxQOXs4kvbE+YGewtI8mzYCOc5GD+D5vwNCfoKyfhjx1t48PvvV8AZrvSHP2FbZQ4i2j35WkoLRVEyLKrBG0MhLsSrrgi0oJhlOhJZoNg0vPipK+IQFg+SYilm8Nn6+naBQ/Lo5MOl2Y=
Message-ID: <8dd980de0708202303l2d3be5bj6682a98df4a40d99@mail.gmail.com>
Date: Tue, 21 Aug 2007 14:03:58 +0800
From: "Kevin Hao" <haokexin@gmail.com>
To: "Xin Zhao" <uszhaoxin@gmail.com>
Subject: Re: How Linux /proc filesystem convert a fd to the actual pathname?
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <4ae3c140708201958x3c88b317o2ba9be64177978f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140708201958x3c88b317o2ba9be64177978f5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I am curious how Linux convert an fd to the pathname?  Does it
> recursively walk back from current dentry to the root?
Using d_path.
> Can someone point me to the right place in the kernel where this
> functionality is implemented?
do_proc_readlink may be the function you want.
