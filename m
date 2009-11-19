Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZKSOf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZKSOf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZKSOf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:35:58 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53260 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZKSOf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Adf/m/nf+YAES/LUC/b7eNAEw+k+t2x9L5LLQiBjBth15BcuKZVZp0Ey1cLPuRqk4C
         VGFUY3KbzVte4LdSC4mZHWrZeJQsIx/coEasKTWPinok/+5K9X+o5WMZVuFi0+WZg3Bv
         N98BgGgZzX0WzeDxfYUXLte6V7YrYYmTlRYQM=
Date: Thu, 19 Nov 2009 22:35:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: khaled MOHAMMED atteya <khaled.m.atteya@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: is kernel keep connection track?
Message-ID: <20091119143511.GA8392@hack>
References: <7f9112a50911190603q2bfc7ee2s7639eab5abcad8df@mail.gmail.com> <7f9112a50911190625m5d77f067u3a2efccf9479872e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f9112a50911190625m5d77f067u3a2efccf9479872e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 04:25:40PM +0200, khaled MOHAMMED atteya wrote:
>Hi all
>
>if i have multiple ISP connection in my linux gateway , can kernel
>keep connection track for each connection?
>
>i mean , suppose i download a file through one isp , i want to
>guarantee that , file will be downloaded through this ISP else it will
>be stopped
>
>and what about this patch "http://www.ssi.bg/~ja/"?
>
>and if  kernel already keep connection track, which minimal kernel
>version do that?
>

I believe ip_conntrack can do what you want, check:

http://conntrack-tools.netfilter.org/

-- 
Live like a child, think like the god.
 
