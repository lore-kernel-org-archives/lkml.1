Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYLVUGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYLVUGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYLVUGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:06:11 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:44667 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYLVUGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VQzaOvedtJoY02827/f7Mh3KwyGCMlD0sLOGE74uTuhYfPAXDHKy1nKEoaP8YZSAVU
         sSYLvraBL4ZnJzaWbDeWodF7Iyj3qxGNE2iCbaSn/V5sjk8f9ZDG/XHr21KIRn3LeSHx
         UnA/Qrq0LpuM4TG8GGvf3VssOmwO1nRmXVgMI=
Message-ID: <c6d9bea0812221206j3edef970t316f104274f961ce@mail.gmail.com>
Date: Mon, 22 Dec 2008 15:06:08 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [RFC PATCH -v4 12/14] fsnotify: add correlations between events
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@zeniv.linux.org.uk, hch@infradead.org, zbr@ioremap.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <1229913601.29604.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215217.27112.75137.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181428s2ae78e30y1e700b2eca07ca96@mail.gmail.com>
	 <1229913601.29604.9.camel@localhost.localdomain>
X-Google-Sender-Auth: 18ed46394252e1d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 9:40 PM, Eric Paris <eparis@redhat.com> wrote:
> A) this isn't a hot path, it's only when a file is renamed.

Yes, sorry, I misread the description of that patch to indicate that
you planned to include a newly-generated cookie in all fsevents.
Re-reading the patch I see that you are still only generating cookies
for renames.  But yeah, better cookie generation will help scalability
if you plan to use them more broadly in fanotify.
 --scott

-- 
                         ( http://cscott.net/ )
