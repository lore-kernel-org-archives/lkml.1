Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbXE2B4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbXE2B4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 21:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbXE2B4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 21:56:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29855 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbXE2B4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 21:56:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PARkhZF+/1MY98X/0gJfW9ci97ormPZOXRnMYRhaGLv2nKEmnpl2ThERrq1tTjogB
	M0cGe1ALTNbMVSqzUiY0g==
Message-ID: <6599ad830705281855w67921bb4kda8813cf993656df@mail.gmail.com>
Date: Mon, 28 May 2007 18:55:52 -0700
From: "Paul Menage" <menage@google.com>
To: "Peter Williams" <pwil3058@bigpond.net.au>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Cc: vatsa@in.ibm.com, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       wli@holomorphy.com, ckrm-tech@lists.sourceforge.net,
       "Balbir Singh" <balbir@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       "Kirill Korotaev" <dev@sw.ru>, kernel@kolivas.org, tong.n.li@intel.com,
       containers@lists.osdl.org, "Ingo Molnar" <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "Guillaume Chazarain" <guichaz@yahoo.fr>
In-Reply-To: <465B7163.7020403@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com>
	 <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu>
	 <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com>
	 <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com>
	 <46577CA6.8000807@bigpond.net.au> <20070528172658.GA18582@in.ibm.com>
	 <465B7163.7020403@bigpond.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
>
> In any case, there's no point having cpu affinity if it's going to be
> ignored.  Maybe you could have two levels of affinity: 1. if set by a
> root it must be obeyed; and 2. if set by an ordinary user it can be
> overridden if the best interests of the system dictate.  BUT I think
> that would be a bad idea.

Something like that already exists (at least for controlling the
bounding set of allowed cpus) via cpusets.

Paul
