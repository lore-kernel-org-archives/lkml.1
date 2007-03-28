Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbXC1Q5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbXC1Q5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXC1Q5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:57:05 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:63731 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151AbXC1Q5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=F7THOHPl4J+bLO8N5UYYb3hCZN6D4XEfyztR82/Wv9jRgVWS1lzOSObg3gWv3waEU1EWZ4Fw7espTYKSjj6EExLj31vEfeL3YCs+VeaNWRGunZU0K7/+Yjmgd1+jrSF99a2l+EzJpUar2BQomKYtHdU2+LhxVqcVEjdt9Q/NHts=
Message-ID: <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com>
Date: Wed, 28 Mar 2007 12:56:59 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Cc: andrea@suse.de, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <200703281847.05356.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200703281847.05356.toralf.foerster@gmx.de>
X-Google-Sender-Auth: 1efb0337374ae8e3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Toralf Förster <toralf.foerster@gmx.de> wrote:
> I compiled current git source 2.6.21-rc5-g28defbe and got this warning:
> ...
> fs/block_dev.c: In function `bd_claim_by_kobject':
> fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
> ...
>

Most of these warnings are really GCC bugs.  Please examine the code
in question.

Lee
