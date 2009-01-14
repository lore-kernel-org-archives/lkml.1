Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbZANAPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbZANAPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbZANAN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:13:58 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37856 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322AbZANAN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:13:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=vOKbnQ6+59/TMNGFnjZb3IoU2KdrUCESwiJxrLZvlKcCw6ZC0oxqB8leFM2T6micUR
         mkoSACd4WQkX9WTTQMrLwWAEGpCvOiqToFaiTmY9QIyL7yQXxhQEq58Exr3Ahn4vAFDg
         oEoRagWiblHXtJP4d7nz3hS1iD13zdgnoUCfM=
Message-ID: <cfd18e0f0901131613l65bff51fo22e86a01ba2c0720@mail.gmail.com>
Date: Wed, 14 Jan 2009 13:13:54 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       vegard.nossum@gmail.com, linux-man@vger.kernel.org, stable@kernel.org
In-Reply-To: <20090113234716.765A8FC3DD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	 <20090113224941.36F19FC3DD@magilla.sf.frob.com>
	 <cfd18e0f0901131514i2f7be7f1t2c6275c26dbb6874@mail.gmail.com>
	 <20090113152457.0d7685ad.akpm@linux-foundation.org>
	 <20090113234716.765A8FC3DD@magilla.sf.frob.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:47 PM, Roland McGrath <roland@redhat.com> wrote:
>> Well yes.  waitid() has been in there since 2.6.9.  I assume that it
>> has had this wait4-emulation mode for that amount of time as well?
>
> Correct.
>
>> Well, we might get away with it.  But formally speaking, we should live
>> with our Linux-specific screwup.
>
> I agree with both of you and I don't care which we do.

I don't feel strongly about this, but lean towards the idea that we
should fix things, as per Roland's patch, and I suspect we can get
away with it, for the reasons I mentioned already.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
