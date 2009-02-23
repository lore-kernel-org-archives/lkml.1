Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZBWS7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZBWS7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZBWS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:59:08 -0500
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:55300 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbZBWS7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:59:07 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-04.arcor-online.net 7606933AE7A
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Mon, 23 Feb 2009 20:01:16 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5; KDE/4.2.0; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902231921.22759.prakash@punnoor.de> <49A2EFF9.9020109@kernel.org>
In-Reply-To: <49A2EFF9.9020109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232001.17240.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 23 Februar 2009 19:50:33 Yinghai Lu wrote:
> Prakash Punnoor wrote:
> > On Montag 23 Februar 2009 07:18:34 Yinghai Lu wrote:
> >> please try, you may need Eric's patch too.
> >>
> >> [PATCH] pci: don't enable too much HT MSI mapping
> >>
> >> Impact: fix bug
> >>
> >> Prakesh reported that his c51-mcp51 system ondie sound card doesn't work
> >> MSI but if he hack out the HT-MSI on mcp51, the MSI will work well with
> >> sound card.
> >>
> >> this patch rework the nv_msi_ht_cap_quirk()
> >> and will only enable ht_msi and try to avoid to enable ht_msi both.
> >>
> >> Reported-by: Prakesh Punnoor <prakash@punnoor.de>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > Hi, I can confirm that the patch works nicely with 2.6.29-rc6. (BTW, my
> > name is written with two 'a's...)
>
> good, will resend to Jesse.
>
>
> what are your correct name with two 'a's?

Well, as in my sender field/email: Prakash (not Prakesh)
