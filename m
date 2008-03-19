Return-Path: <linux-kernel-owner+w=401wt.eu-S940068AbYCSX4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940068AbYCSX4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161298AbYCSWaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:30:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:65045 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161196AbYCSWah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E6Px/kQ2s/5VDoL00EIcJ74mCWo1781BwX31YERr7RzMswSjZzW1R/FzrUYtC/Esd0+NvvoXV1QW5iZhmT9o6EzoE8blbZ+bsLwx2q4K+vKp3LZDy7FEne0VmCrGY7HqcGJnRxRjkS7x+vD+d8KhNNpq1i5d5bRQzVvvmM9Xk7E=
Message-ID: <45a44e480803191530p27ec9575l260d6de063a8d6bf@mail.gmail.com>
Date: Thu, 20 Mar 2008 06:30:37 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
Cc: "Markus Armbruster" <armbru@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <20080319113745.d3873de0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	 <87k5kt6vd3.fsf@pike.pond.sub.org>
	 <45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
	 <871w6z6ajs.fsf@pike.pond.sub.org>
	 <45a44e480802260701o7c616e3bjd5f86f4143be791b@mail.gmail.com>
	 <87iqzjat6e.fsf@pike.pond.sub.org>
	 <45a44e480803190424s51b85efbk39ab3bfce4cb924a@mail.gmail.com>
	 <20080319113745.d3873de0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 2:37 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  Do we need some of all of that patch in 2.6.25?  I wasn't aware of such a
>  need.
>
>  If the drivers/video/fb_defio.c hunk of that patch fixes something then I'd
>  be inclined to merge the whole thing - adding a new driver won't hurt
>  anyone.
>

Yes, the defio hunk is a bugfix. I agree with pushing the whole thing
to 2.6.25 if there are people who need it in 2.6.25. I believe there
is no risk of impact on anyone else.

Thanks,
jaya
