Return-Path: <linux-kernel-owner+w=401wt.eu-S1762119AbYBZOLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762119AbYBZOLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYBZOLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:11:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:40940 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbYBZOLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=khETza5bpX5PJp7AP0VmYCsqEBsMj7zK26gtapT7hwyuHKwCc4mFkUOcBoio+K+ljhMi/4pUL14wU9khfMORD1JzZqH/OGv2WoeusL7dbUyuLEVjLUewd77BvmVbXI7oYqJyg5sD+IuCA7VQFkxLmjltDP+YcKZJaXvKIreIlSo=
Message-ID: <45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
Date: Tue, 26 Feb 2008 09:11:45 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <87k5kt6vd3.fsf@pike.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	 <87k5kt6vd3.fsf@pike.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 8:03 AM, Markus Armbruster <armbru@redhat.com> wrote:
>
>     Subject: [PATCH 1/1 2.6.24] fbdev: defio and Metronomefb
>     From: Jaya Kumar <jayakumar.lkml@gmail.com>
>     Date: 2008-02-18 13:41:26

Hi Markus,

Andrew pointed out that there may be race conditions associated with
this patch. [ http://marc.info/?l=linux-fbdev-devel&m=120376473020396&w=2
] So I would not encourage anyone to merge it. I'll try to figure
things out this weekend.

Thanks,
jaya
