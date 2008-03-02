Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYCBSF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYCBSF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYCBSFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:05:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:56483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYCBSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:05:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ttH1MCxn4aU7c50ucLdlTEsPSeVjbQVSamh4ThAMwshpvQJklUjfgAjtHD8eMCnm/lyc8vVI/m/GGGYF0NNLqvXfbXYc/+CB1sdOqQwqHy6s6dt2gMQcjwcs2PNmFcQYiPPedVOyZ2b0QNR2Dogs9kXJ1SF8KkjEin5aUKAqUac=
Message-ID: <3d8471ca0803021005o46f99282l77d412306877607a@mail.gmail.com>
Date: Sun, 2 Mar 2008 19:05:49 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Pawel Plociennik" <paplociennik@gmail.com>
Subject: Re: [PATCH] chroot= as a new kernel parameter
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200803021859.30473.paplociennik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803011409.59526.paplociennik@gmail.com>
	 <3d8471ca0803020800m6ef56c7enc5e9b28852266c9f@mail.gmail.com>
	 <200803021859.30473.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 12:59 AM, Pawel Plociennik
<paplociennik@gmail.com> wrote:
> On Sunday 02 March 2008 11:00, Guillaume Chazarain wrote:
>  > Wouldn't booting with 'init=/usr/sbin/chroot /path /sbin/init' achieve
>  > the same effect?

>  I think that procces which has pid 0 is a special procces

You mean pid 1, right? ;-)

> because it
>  removes a *zombie* procceses so it is good to use a *dedicated*
>  program for it such as a /sbin/init .
>  /usr/sbin/chroot doesn't remove a *zombie* procceses :-(

Sure, but chroot should then exec /sbin/init as per the given kernel
command line. And then you run a real init.

I cannot try it as I don't have another distribution installed in a
subdirectory, but if you could test it we would quickly know if it
works or not.

Thanks.

-- 
Guillaume
