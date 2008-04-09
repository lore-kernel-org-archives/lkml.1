Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYDIRvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYDIRvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYDIRvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:51:25 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:49037 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYDIRvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kqvXB9OSq+Niir6hkLbzHSWeI0UjLcTD6PypN26NyXwO/oOc/KGmlfJOkd6PKyNEB3iNWyjKGd54MG+ZErFXTyxHZ8CKsD6IbX/GVh4/VM4dQo+ulkMhXOhCzN6fyoyFgq4cl/xOHnrv7QCwuNAo4eSEU8hcVcZXvh2b2X5wwdE=
Message-ID: <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
Date: Wed, 9 Apr 2008 19:51:23 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080408184301.651388000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>   * Cleanup usages of cpumask_scprintf in the following files and add
>     another interface to use cpulist_scnprintf where appropriate.

On Mon, Apr 7, 2008 at 8:22 PM, Mike Travis <travis@sgi.com> wrote:
>  Part of the change is readability, but also looking towards the future
>  of 16k/64k/??? # of cpus, the straight mask approach will overflow the
>  PAGE_SIZE buffer provided (though some pathological cases will overflow
>  the range method as well.)  So we'll need some advancement in the format
>  of the printout.

Btw, I think you can now push for a deprecation of the 'old' mask
attributes, with the justification you have given above. The other
possibility is to change sysfs to provide bigger attribute buffers
(CCed Greg for this).

Bert
