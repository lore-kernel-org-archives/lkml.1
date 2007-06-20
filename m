Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXFTVEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXFTVEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXFTVDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:03:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:56767 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbXFTVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mBQx56EYZ0r6qZJAupgaRFAOBW7KvNOGSmms9Rgz6jDqU1UaC6PhOi8RBGnLNg10Xh3ArtJfbZDqzGzYpRu8FgVmztysiSGWqsUtsuxNC0mVrFo7Ud4ksLQzuKQ8zYoW1S0wa8T8ZzjlqxwlQBl1qA+jYkVkIjZzDIr5OPxSwbw=
Message-ID: <9a8748490706201403v1cee4467m78d143db86be02fc@mail.gmail.com>
Date: Wed, 20 Jun 2007 23:03:44 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: scripts/checkpatch.pl refers to non-existent Documentation/Documentation/volatile-considered-harmful.txt
Cc: "Andy Whitcroft" <apw@shadowen.org>, linux-kernel@vger.kernel.org
In-Reply-To: <ada3b0m8hr0.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ada3b0m8hr0.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/07, Roland Dreier <rdreier@cisco.com> wrote:
> Commit 4a0df2ef added the following to scripts/checkpatch.pl:
>
>     print "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n";
>
> but Linus's tree has no such file.  not sure what the right thing to
> do here is, since I assume we do ultimately want something of the sort
> in Documentation...
>

That document is in the -mm kernel currently. As soon as it hits
mainline from there checkpatch.pl will be right :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
