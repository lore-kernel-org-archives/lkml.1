Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYDJQPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYDJQPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYDJQO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:14:57 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:24537 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbYDJQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a+umZubOrRvbAnSu8yRX/OYopOOdneXFaykx+j+Gad5e5E6odv/joaLkIidgB3NqpV0Qdl+LlNLWI0YzHyBiJl58UKA/JrejVwL3eu53Wj87NFf9Ne64E+rGcZfJdcZqRZPxLNmfC1PhX9I7Db4MW+TjdbJ4DBi1bDJLZVKM5Kg=
Message-ID: <36ca99e90804100914n4b08cc9di9a6ab8b936f25644@mail.gmail.com>
Date: Thu, 10 Apr 2008 18:14:55 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080410071009.a5232b12.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
	 <20080410071009.a5232b12.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 2:10 PM, Paul Jackson <pj@sgi.com> wrote:
> Bert wrote:
>  > Btw, I think you can now push for a deprecation of the 'old' mask
>  > attributes, with the justification you have given above. The other
>  > possibility is to change sysfs to provide bigger attribute buffers
>  > (CCed Greg for this).
>
>  On the other hand, and my main point of this message, I can't
>  see deprecating the mask format files on account of this sort
>  of analysis.
>
My statement from above doesn't reflect my opinion. I'm still in
flavor with the mask output. And from this discussion, I found a new
point for the mask output: its bounded ;-)

I just wanted to note, that these new list attributes would be the
only way to 'change' the api, ie. introduce a new api and deprecate
the old one, and not change the format of the present api.

Unfortunately, to support the mask attributes beyond 4k cpus, sysfs
has to support greater attribute buffers.

Bert
