Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYJRBiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYJRBiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 21:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYJRBiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 21:38:04 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:35863 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752142AbYJRBiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 21:38:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=f9LUouiCqv+0nnr1pulYma/JzC1ef7Cr2mJO2LlBOHdX9LJx3Y/jPTX+VXGviC3cILz1n+OdvbBygdGDageiKeVWx8wos8/XY9Dq8CH3eclWgK1elQdWyqVxQBeozp+IRf5kzk9LXtCZa8KeCHFFp12tgr1C0fBQDSNjv9RTgPw=  ;
X-YMail-OSG: R035fQQVM1mJlk5fDMIOoJcgdxGv2OMLo0NGt3APGEQoh0LxIY4FSN10Lg0VrR1k2NDSHo.oWkhYSpRDyRV8xMM1_LF9_qXd2IdMygLKfuq6heIjFaoEkPdJzMW_V5bgbBsbtLgXit.lcoR9nugPXHK.7NLEGVSujKx.x4T7gGl8KTe8hR_U5dnlGZf6
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Date: Sat, 18 Oct 2008 12:37:49 +1100
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810181237.49784.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 October 2008 08:29, Dave Airlie wrote:
> Hi Linus,
>
> This is a new tree, I had a conflict with your latest tree due to some
> trivial cleanups you merged. I've added the fix for CVE-2008-3831 which is
> unembargoed.
>
> Please pull the 'drm-next' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> drm-next
>
> This contains two patches outside the DRM git tree to add exports for GEM
> functionality while we await Nick Piggins vmap and shmem changes.

OK. I was hoping that kmap_atomic_pfn thing *never* see the light of
mainline ;) Because hopefully the vmap improvements should be OK for
2.6.28 as well...

But it's already there. OK, if vmap patches go upstream, then it can
be switched over and the export removed before the release...

Thanks,
Nick
