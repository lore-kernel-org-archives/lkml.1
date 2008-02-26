Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbYBZPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbYBZPB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYBZPBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:01:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:25308 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbYBZPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QhMJsW5yCeSguRpZmHhuLLonCwfc7AqFFVdb3vS+WZoCp/UtahpUWR4sBOu6SyjP4QBZcVBaOafFzS2KGoaEQJgMUvnyG7plXf5uSxVDe8bpDozShxZqFDXrc0fVUhNOsSlbNCYgHYQQRm0WfGajLVrQpd563RP/re29yC3xggw=
Message-ID: <45a44e480802260701o7c616e3bjd5f86f4143be791b@mail.gmail.com>
Date: Tue, 26 Feb 2008 10:01:16 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <871w6z6ajs.fsf@pike.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	 <87k5kt6vd3.fsf@pike.pond.sub.org>
	 <45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
	 <871w6z6ajs.fsf@pike.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 9:45 AM, Markus Armbruster <armbru@redhat.com> wrote:
>
>  What about pushing the fb_defio fixes independently of any new
>  fb_defio users?  If fb_defio was worth merging into Linus's tree, it
>  should be worth fixing there, whether new users are in shape already
>  or not.

I think that Andrew's message is saying that there may be a race
condition in the defio patch itself as opposed to the defio user
patch.

If there is no race condition or other problems, then I think it would
make sense to merge the defio patch independent of metronomefb or
other new patches that use defio.

Thanks,
jaya
