Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZJSSvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZJSSvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZJSSvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:51:01 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:59496 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZJSSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jzmVQZn90YK9ErMx5fLHRtSeAuWP4JlJnjDukMOYARz0fdVBjKmCOfQUvbxXwczlJ9
         yAbj6ToJr3HSDXU9FcSwcaT822CkUptDev+vi+mzL6P32EnIFBVbpectHIaYEz6t+DAA
         BYI6GHYFpPSknAES0LFMANd6WZuFwNLh+FVmI=
MIME-Version: 1.0
In-Reply-To: <20091019102116.222ff9c3.peter@piie.net>
References: <20091019102116.222ff9c3.peter@piie.net>
Date: Mon, 19 Oct 2009 20:51:04 +0200
Message-ID: <9ea470500910191151j370cec68w67ee8e31f42f3303@mail.gmail.com>
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 19, 2009 at 10:21 AM, Peter Feuerer <peter@piie.net> wrote:
> what do you think about this patch?

I don't think it is worth the trouble. Just compare the changes your
patch introduces with a simple

 temp * 1000

you can do in userspace.

If this were a standard interface then maybe the changes could be
warranted but it doesn't seem like so...

-- 
Regards/Gruss,
Boris
