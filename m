Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXEWJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXEWJVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbXEWJVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:21:14 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:53090 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbXEWJVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PbFi6/aWWQ3ZLZNv1kLklti20dlccafVilb74e00xTCwZ6ZLHUiW7yJ1Q1e3Y1MHQzClsJAYk/oqmWZ/sdKDCAuO3DfoGT9KsIKL2XyeNjrmxrHr6BlX++FTmf+tYYc7+rV+GAAfmQIhd02yB6K7ZDZVs8LexQeOcby0Y7Rq42E=
Message-ID: <4de7f8a60705230221m76fc55a3jc48a0d19c086fb3b@mail.gmail.com>
Date: Wed, 23 May 2007 11:21:12 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] file as directory
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
	 <20070522221045.GH4095@ftp.linux.org.uk>
	 <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
X-Google-Sender-Auth: 60d13d531bda7717
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > As for unlink...  How do you deal with having that thing
> > mounted, mounting something _under_ it (so that vfsmount would be kept
> > busy) and then unlinking that sucker?
>
> Yeah, that's a good point.  Current patch doesn't deal with that.
> Simplest solution could be to disallow submounting these.  Don't think
> it makes much sense anyway.
>

Hmm, think about /your/path/qemu-disk1.img/boot ,
/your/path/qemu-disk2.img/usr , ...

Jan
