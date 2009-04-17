Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZDQWva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZDQWva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZDQWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:51:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44811 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZDQWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vESE6Y8x0HNLW9vZg4bhOcwQC929E9jqCHXBMMUGDr3xVPLAigJzdnikMPOf/O6IHt
         mogbUpTk9vDN2hCXk91Q5WcI5HSTt6pY8ZB8gRhrPiTbuP1WBOIGUv+0RybIgKurgfiY
         psIlVA52XrTyQfW1ddGJa/7L9yezzh/iGhebQ=
Date: Sat, 18 Apr 2009 00:51:11 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and
	mm->mmap_sem ...} causes Xfbdev not working
Message-ID: <20090417225110.GA6972@linux>
Mail-Followup-To: Krzysztof Helt <krzysztof.h1@poczta.fm>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrey Borzenkov <arvidjaar@gmail.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com> <20090409125850.GA2727@linux> <20090410222122.87be60f6.krzysztof.h1@poczta.fm> <20090410220521.GB21294@linux> <20090411080415.7fe924a2.krzysztof.h1@poczta.fm> <49E05C36.9040204@s5r6.in-berlin.de> <20090411110840.GA7108@linux> <20090411150359.GA8265@linux> <20090417182507.0bd85ccc.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417182507.0bd85ccc.krzysztof.h1@poczta.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 06:25:07PM +0200, Krzysztof Helt wrote:
> On Sat, 11 Apr 2009 17:04:00 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > It would be great if someone could help me to test this patch (against
> > latest Linus' git - no need to revert 66c1ca).
> > 
> 
> I can confirm the patch fixes the issue on radeonfb and cirrusfb drivers tested so far.
> 
> Regards,
> Krzysztof

Thanks for testing!
-Andrea
