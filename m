Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbXJWWaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbXJWWaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbXJWWaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:30:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:60068 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXJWWaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gPsSDZPCNKROmUnsWMAiInU3UusET8mRZDzyyIhNkqY3MWGHCl9z0at+LJd9fMsvCDeY32oqDMkuil8q36PnhJZy4vwzAyaA0ppbY44BnMkNeXFX6Iks/lNG2PSpPrm2SjA3hsc/Pn6qUdoS9CsgyMmJkkGsZvwT+Y/IUgAwB5o=
Message-ID: <a4e6962a0710231530i76ddfde6jd488b32619d313c2@mail.gmail.com>
Date: Tue, 23 Oct 2007 17:30:04 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: [V9fs-developer] [PATCH] 9p: v9fs_vfs_rename incorrect clunk order
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071023001447.GA5628@ionkov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071023001447.GA5628@ionkov.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
> In v9fs_vfs_rename function labels don't match the fids that are clunked.
> The correct clunk order is clunking newdirfid first and then olddirfid next.
>
> Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
Acked-by: Eric Van Hensbergen <ericvh@gmail.com>
