Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZGVEwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZGVEwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGVEwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:52:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZGVEwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:52:35 -0400
Message-ID: <4A6699F2.8020605@zytor.com>
Date: Tue, 21 Jul 2009 21:47:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.1) Gecko/20090715 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ted Merrill <atheros@embuildsw.com>
Subject: Re: khttpd fate
References: <43e72e890907171815x3a85c788k1b4c0f72954db9e5@mail.gmail.com> <20090722002039.GF11051@bombadil.infradead.org> <4A665F09.7050104@zytor.com> <20090722015706.GB6025@redhat.com>
In-Reply-To: <20090722015706.GB6025@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 06:57 PM, Dave Jones wrote:
> On Tue, Jul 21, 2009 at 05:36:25PM -0700, H. Peter Anvin wrote:
>  > On 07/21/2009 05:20 PM, Kyle McMartin wrote:
>  > > 
>  > > I think it kind of got replaced by tux, which Red Hat shipped for a
>  > > while, but has been dropped now. I seem to recall davej mentioning a
>  > > while ago that apache had gotten much better at serving static content,
>  > > which is what khttpd/tux were very good at.
>  > > 
>  > 
>  > Also, lighttpd does really well, all in userspace.  After all, static
>  > http serving really is mostly a bit of header parsing followed by
>  > sendfile(), so as long as a user-space process doesn't just sit on a
>  > bunch of memory it can be done very cheaply.
>  
> I think the rise of dynamically generated content was a big thing that
> killed it off. With more and more of the web getting ajaxified, and the
> php etc being offloaded to apache anyway, it just makes more sense to
> have one webserver do everything as long as it's "fast enough".
> 
> I wrote something up on this a few years back when I made the decision to
> drop Tux from the Fedora kernel. http://kernelslacker.livejournal.com/tag/tux
> 

I can certainly explain why we don't use it on kernel.org, which is
almost all static content.  We simply don't want to have to deal with
multiple web servers if we don't have to, and with sendfile() and
threading in Apache, it's reasonably efficient.  If it wasn't, we would
probably go to lighttpd.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

