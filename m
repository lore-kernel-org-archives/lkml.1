Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbXFXWvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbXFXWvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFXWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:51:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:50887 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXFXWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=czETfyYTjaxYgSVjgftPbtZup9F8+ZQXBluQtLMxZS4tgYJMWtxRc0r78qKFf7tJ4QqqM+crZ44T4wMovLAR8QDkzjZAVG5zBG+TrBAdtt9FTyaz5cNceNDyZWsTcGaT2oadX+eCpFWUZCDjjTkA0YhSpN98NAb20eX7tXEZeu4=
Message-ID: <9a8748490706241551l543683e2jb0665e0ea2d980c9@mail.gmail.com>
Date: Mon, 25 Jun 2007 00:51:12 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
Cc: "Jay L. T. Cornwall" <jay@esuna.co.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <467BE118.4090308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467B12CA.5060405@esuna.co.uk> <467BE118.4090308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/07, Chuck Ebbert <cebbert@redhat.com> wrote:
[snip]
>
> Step 1: run fsck on the filesystem.
>
I agree that running fsck on the filesystem is a good idea, but still,
even a corrupt filesystem should never be able to cause an Oops. In
fact, nothing done from userspace should be able to cause an Oops.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
