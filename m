Return-Path: <linux-kernel-owner+w=401wt.eu-S941617AbYCSWqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941617AbYCSWqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936719AbYCSVQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:16:19 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:46481 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936714AbYCSVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:16:18 -0400
Message-ID: <45a44e480803190424s51b85efbk39ab3bfce4cb924a@mail.gmail.com>
Date: Wed, 19 Mar 2008 19:24:25 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <87iqzjat6e.fsf@pike.pond.sub.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 6:45 PM, Markus Armbruster <armbru@redhat.com> wrote:
>
>  Any progress on this?
>
>  Considering that fb_defio is utterly broken without the fix (writing
>  the frame buffer makes the VM endlessly invoke vm_ops.page_mkwrite()),
>  wouldn't it make sense to merge the fix even if it still has issues?
>

Yes, Andrew has merged the fix into -mm. I see it in mmotm

http://userweb.kernel.org/~akpm/mmotm/broken-out/fbdev-defio-and-metronomefb-v4.patch

Thanks,
jaya
