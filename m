Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZAENcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZAENcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZAENcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:32:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:7155 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZAENcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ob9n4sHyj4u9i7kIzjnz5qW70PTbZzwjv6whHIGobodxUos2Bjshr0qOe6cYcrBhaT
         iK2nISt1sicGZZKvqwSezG7hk5T/LQLRGcoDY4L54YqYNgRyflJ5hK5ZeaPGzEt/Mkq6
         EhqOE6QAtTEDq1PR26xNx3rIBMggCuA/CL12k=
Message-ID: <84144f020901050532m3c8a4d68q655514051d4e259a@mail.gmail.com>
Date: Mon, 5 Jan 2009 15:32:13 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH V3 12/17] Squashfs: header files
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
In-Reply-To: <E1LJnJo-0002Lz-2y@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1LJnJo-0002Lz-2y@dylan.lougher.demon.co.uk>
X-Google-Sender-Auth: 79ac4b7d6e52d3af
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

On Mon, Jan 5, 2009 at 1:08 PM, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
> +#define TRACE(s, args...)      pr_debug("SQUASHFS: "s, ## args)

You've probably heard this before but silly "tracing" such as:

    TRACE("Entered squashfs_fill_superblock\n");

should really be removed from the filesystem code.

> +#define ERROR(s, args...)      pr_err("SQUASHFS error: "s, ## args)
> +
> +#define WARNING(s, args...)    pr_warning("SQUASHFS: "s, ## args)

I think you're supposed to #define pr_fmt() in your header instead of
adding wrappers like these.

                        Pekka
