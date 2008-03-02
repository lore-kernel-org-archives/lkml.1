Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbYCBUsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbYCBUsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYCBUsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:48:42 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:38116 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbYCBUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WZVEQXC7VkdG6nl/2m4dN0724I54cgoY9rV04/WXe/4220Ijd2Qk2dSFnWxW4m2UClwviHEI3bAZ/GmT1cC7HtbyN8RnVhTV5W4qM6rYafQOhqpY+BpycPV3Vn7VEBU8ZElwIzXLi6NVuZ5J6HweMpn4npVqHKVQOCy3g5YD4Pw=
Message-ID: <84144f020803021248r53c3d179ga514c0c426e1e2d6@mail.gmail.com>
Date: Sun, 2 Mar 2008 22:48:39 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] slub: fix possible NULL pointer dereference
Cc: "Christoph Lameter" <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080302202824.GA9032@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080302202824.GA9032@cvg>
X-Google-Sender-Auth: 0df936dd6c869c1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2008 at 10:28 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This patch fix possible NULL pointer dereference if kzalloc
>  failed. To be able to return proper error code the function
>  return type is changed to ssize_t (according to callees and
>  sysfs definitions).
>
>  Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
