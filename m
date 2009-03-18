Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbZCRTZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbZCRTZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759920AbZCRTVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:21:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:48335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811AbZCRTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CwFieJfWa3lrHEiiruLFWvRWQBTu03457TjQYLegZ4QuZbJoKZ2wIcg0MA/dLUAsY+
         yL8rQ1aYS8t7SrJrX92DLyWFWZ3Z9Z435Gzx7ewS9hnSUHtbSuwqEpENoTTQBeM0CRkf
         c+daLP0QdBddHF4XDiEwhPEj0oRpe3X/XRY9o=
MIME-Version: 1.0
In-Reply-To: <d760cf2d0903181029r43bf417u502b46e08348f6ae@mail.gmail.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>
	 <alpine.DEB.1.10.0903171237180.21582@qirst.com>
	 <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>
	 <alpine.DEB.1.10.0903171355410.26058@qirst.com>
	 <49C11088.7000205@vflare.org>
	 <alpine.DEB.1.10.0903181258110.15570@qirst.com>
	 <d760cf2d0903181029r43bf417u502b46e08348f6ae@mail.gmail.com>
Date: Wed, 18 Mar 2009 12:21:30 -0700
X-Google-Sender-Auth: 96c01b901ae5ab27
Message-ID: <84144f020903181221t480caa5dhef0e581a7bef006@mail.gmail.com>
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Nitin Gupta wrote:
>>> > Slab memory is not backed by vmalloc space.
>>> Oh, it uses "low memory". Still not good for compcache :)

On Wed, Mar 18, 2009 at 10:28 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
>> Only if you use 32 bit.

On Wed, Mar 18, 2009 at 10:29 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> Yes, this point is for 32-bit only - many users were unhappy with
> compcache size limit due to small vmalloc area on x86-32.

Yeah, I can see the point in having a custom allocator for this. But
quite frankly the xvmalloc code is just too ugly to live with. You
might want to make it look like kernel code as per CodingStyle and
change the name to something less generic.
