Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbYBMOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbYBMOyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYBMOyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:54:14 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:34641 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYBMOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WspYYyA4tm0KfzD+DSA8Rsx5hfzGPkz+lydkvWZNzkMv2Hc0lhE9LJt0weOLGYzVba+EG4zkC3n4VFWA+ATHT1YJtc7/+GrOJNb2Q/jmxNjCkpCbsmcVZHVk+5j0N7iKOOxuC2oiuL5xbpHNvXqVa5d096mJA+1kvVPPobRe/EY=
Message-ID: <84144f020802130654w51901fb1hf29d39ba86d87414@mail.gmail.com>
Date: Wed, 13 Feb 2008 16:54:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: [PATCH] fs/coda: remove static inline forward declarations
Cc: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
       jaharkes@cs.cmu.edu, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0802130838100.4463@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi>
	 <Pine.LNX.4.61.0802130838100.4463@chaos.analogic.com>
X-Google-Sender-Auth: 95f06d6f4fee662e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 3:43 PM, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> You should not remove things just because you don't think they
> are necessary. They do no harm and removing them can cause
> code checking tools to issue diagnostic messages.

Err, no, Ilpo's patch looks good and the redundant declarations should
be removed. Andrew, please queue up this patch.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
