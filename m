Return-Path: <linux-kernel-owner+w=401wt.eu-S938721AbXG1Bev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938721AbXG1Bev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 21:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938385AbXG1Bel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 21:34:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:36765 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933913AbXG1Bek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 21:34:40 -0400
X-IronPort-AV: i="4.19,192,1183348800"; 
   d="scan'208"; a="46730339:sNHT24540740"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Yoann Padioleau" <padator@wanadoo.fr>
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
Date: Fri, 27 Jul 2007 21:38:23 -0400
User-Agent: KMail/1.9.5
Cc: "David Howells" <dhowells@redhat.com>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200707270944.LAA17167@ifs.emn.fr> <22618.1185531297@redhat.com> <87lkd29mk9.fsf@wanadoo.fr>
In-Reply-To: <87lkd29mk9.fsf@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707272138.23323.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 28 Jul 2007 01:34:38.0931 (UTC) FILETIME=[76841A30:01C7D0B7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 27 Jul 2007 06:18, Yoann Padioleau pondered:
> David Howells <dhowells@redhat.com> writes:
> 
> > Yoann Padioleau <padator@wanadoo.fr> wrote:
> >
> >> When comparing a pointer, it's clearer to compare it to NULL than to
> 0.
> >
> > Can you make them of style:
> >
> > 	if (!x)
> 
> Yes I can. I can make another semantic patch later to do that
> transformation. But some people may prefer (x == NULL) to (!x)
> so I don't know. I think that transformation 
> some 0 to NULL is less controversial.
> 
> 
> >
> > instead?

If there is a definite style or semantic preference that everyone should live 
with - does it make sense to put checks in checkpatch.pl to enforce it?

-Robin
