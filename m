Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbZEHXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbZEHXCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZEHXCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:02:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34323 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZEHXCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=joMa2FAnAmHJbxYtPU134oQtdNRDOuza6yWYJ0/JAnMY9OPP8a9uR7XpfzG8ZmrWhI
         p0fRRjIrEd/JlZCKPuRD3/6JVTJysuRQsRsaQvjj1WitXLCyxSq+MZWxGgCTD8laCPy1
         zx2XY5nYasABgD4cWx2peS0rqBgIyH1OBw0qU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: nigel@tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Sat, 9 May 2009 01:05:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905082144.57955.bzolnier@gmail.com> <1241819971.19600.288.camel@nigel-laptop>
In-Reply-To: <1241819971.19600.288.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905090105.58243.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009 23:59:31 Nigel Cunningham wrote:
> Hi.
> 
> On Fri, 2009-05-08 at 21:44 +0200, Bartlomiej Zolnierkiewicz wrote:
> > Please proceed to Plan B then.
> > 
> > Adding third core code framework to do the same thing is out of question
> > (probably same should have been said about adding second one in the past).
> 
> Why? We have plenty of history of having multiple implementations of
> things (slub, slab and slob...).

With all respect to sl*b developers but things such as sl*b etc. are on
whole different level when it comes to complexity because their interactions
with weird hardware configurations are quite limited.

> > Moreover you will for sure hit much more regressions than you expect
> > (I "love" seeing over and over again when people/companies get trapped
> > into fallacy of superiority of their _own_ solution).
> 
> That's just wrong. TuxOnIce deliberately doesn't remove any of swsusp or
> uswsusp so that there's no chance of users having regressions. It
> provides the _option_ of being a drop in replacement for swsusp, but it
> doesn't force users to take that option.

OK.  What is exactly your plan for transition and for swsusp removal then?

> Regressions happen at the moment because TuxOnIce isn't included in
> vanilla. Users update from one version of stable to the next or from one
> version of head to the next and expect TuxOnIce to keep working, and it
> doesn't always do that because of changes to the vanilla code that
> require an updated patch.

I mean [u]swsusp -> TuxOnIce regressions.

> > I really wouldn't consider teaming with Rafael to work on "swsuspOnTux"
> > (evolving the in-kernel code while re-using chunks of TuxOnIce code) as
> > a bad Plan B.  It has the potential of resulting in a solution clearly
> > superior to all existing ones (TuxOnIce included).
> 
> If there are features in swsusp that TuxOnIce is lacking, or features to
> uswsusp that TuxOnIce is lacking, please tell me what they are and I'll
> implement them. In saying this, I don't deny that TuxOnIce code can
> still be improved - there's a lot I'd still like to do.

Instead of new features I would rather see more effort being put into making
the _core_ TuxOnIce (I mean patch #8 here) smaller (8 KLOC is still a lot,
just to put things into the right perspective the current in-kernel content
of kernel/power/ is 5.5 KLOC) and with more documentation inside the code.

Thanks,
Bart
