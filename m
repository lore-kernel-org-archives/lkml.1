Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYIJRvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYIJRvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYIJRvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:51:16 -0400
Received: from outbound-mail-160.bluehost.com ([67.222.39.40]:60571 "HELO
	outbound-mail-160.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751846AbYIJRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:51:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=gY6t3s6ejIPEFEhIgjkLceSEqLKo1gr4oVEoOa6/+1IQ7DC0GWGhhDtWwjbK2oJqMxpYgnIfYHz1wDQAlDdJAlfg5XzupilG9pE8bh7yFByLnyerwk09rOftemtUlLDi;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [2.6 patch] fix pciehp_free_irq()
Date: Wed, 10 Sep 2008 10:51:11 -0700
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <200809091140.41791.jbarnes@virtuousgeek.org> <20080827220526.GR11734@cs181140183.pp.htv.fi> <16115967.1221000743809.kaneshige.kenji@jp.fujitsu.com>
In-Reply-To: <16115967.1221000743809.kaneshige.kenji@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101051.11488.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 9, 2008 3:52 pm Kenji Kaneshige wrote:
> ----- Original Message -----
>
> >From: Jesse Barnes <jbarnes@virtuousgeek.org>
> >To: Adrian Bunk <bunk@kernel.org>
> >Subject: Re: [2.6 patch] fix pciehp_free_irq()
> >Date: Tue, 9 Sep 2008 11:40:41 -0700
> >Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
> >   linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
> >
> >On Wednesday, August 27, 2008 3:05 pm Adrian Bunk wrote:
> >> This patch fixes an obvious bug (loop was never entered) caused by
> >> commit 820943b6fc4781621dee52ba026106758a727dd3
> >> (pciehp: cleanup pcie_poll_cmd).
> >>
> >> Reported-by: Adrian Bunk <bunk@kernel.org>
> >> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> >Applied to my linux-next branch.  Kenji-san do you think this should go
> > into 2.6.27?  I haven't heard any regression reports about it, but it
> > does seem like a good and simple fix...
>
> Though regression was not reported, it is actually a regression internally.
> It doesn't have a big impact against the hotplug controller that supports
> "command completed interrupt", but it might have a impact against the
> controller that doesn't support "command completed interrupt". So I think
> it should go into 2.6.27. As you said, the patch looks good and simple.

Ok, thanks, I've queued it up for 2.6.27.

-- 
Jesse Barnes, Intel Open Source Technology Center
