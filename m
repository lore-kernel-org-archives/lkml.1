Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZJBO6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZJBO6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZJBO6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:58:43 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:59382 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZJBO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:58:43 -0400
Date: Fri, 2 Oct 2009 10:58:25 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Peter Jones <pjones@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "ketuzsezr@darnok.org" <ketuzsezr@darnok.org>,
       alex.zeffertt@eu.citrix.com, Martin Wilck <Martin.Wilck@ts.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iSCSI/iBFT: use proper address translation
Message-ID: <20091002145825.GA14826@andromeda.dapyr.net>
References: <4AC47DED0200007800017743@vpn.id2.novell.com> <4AC5234C.5030409@citrix.com> <20091002012806.GB27478@andromeda.dapyr.net> <4AC5C7130200007800017A42@vpn.id2.novell.com> <4AC60EE3.4070708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC60EE3.4070708@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 10:32:03AM -0400, Peter Jones wrote:
> On 10/02/2009 03:25 AM, Jan Beulich wrote:
> >>>>Konrad Rzeszutek<konrad@darnok.org>  02.10.09 03:28>>>
> >>The issue as I've come to understand is that the virt_to_phys on
> >>memory below the 1MB does not work. Alex suggested another fix which
> >>ioremap's the iBFT region, but I think this patch by Martin does the same 
> >>job.
> >>
> >>Either way, it looks good to me.
> >>
> >>Signed-off-by: Konrad Rzeszutek Wilk<ketuzsezs@darnok.org>
> >
> >With both ofyou having signed off on it - who's going to push this to
> >Linus? I'm specifically asking in case I'm expected to.
> 
> Not sure how that's supposed to work, but I'm cool with you doing it ;)

Yeah me too :-)

P.S.
In the past I pushed it off to Greg KH and/or Mike Christie.
