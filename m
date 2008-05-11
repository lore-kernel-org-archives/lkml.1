Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbYEKIXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbYEKIXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 04:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYEKIX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 04:23:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59036 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbYEKIXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 04:23:25 -0400
Date: Sun, 11 May 2008 10:24:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       adobriyan@sw.ru
Subject: Re: [PATCH] Remove *.rej pattern from .gitignore
Message-ID: <20080511082401.GA25866@uranus.ravnborg.org>
References: <200805021410.11445.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805021410.11445.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 02:10:08PM +0300, S.Çağlar Onur wrote:
> Hi;
> 
> With commit "3f1b0e1f287547903f11fa1e6de7d2765597766e" Linus's current git tree starts to ignore any "*.rej" files. So "git status" no longer shows these files, but the ones who works with quilt patchsets, this not makes life easier as expected. Because sometimes a work flow (at least for me) requires "quilt push -f" followed by "git status" to see unresolved merge conflicts, work on these conflicts to correct them and finalize the patch with "quilt refresh".
> 
> And if there are some "*.rej" files exists in tree, for whatever reason, this means something goes really wrong there and i think this situation not deserves to be ignored.
> 
> This is the second time i came across with this patch cause the first one (http://lkml.org/lkml/2007/7/18/327) ends up nowhere :)
> 
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

Hi S.Çağlar.

I fixed up the changelog and apllied this to kbuild-fixes.

	Sam
