Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZDRD5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZDRD5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 23:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZDRD5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 23:57:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:35628 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZDRD5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 23:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i3BefpNsLLrGk2vxWXi9acpOHPEXEqzHaaO+cLEUxu97Pz1HTHCG0K1VFwr96Tw0Ac
         QloC1rsxT+n9FdQBxtivwpKFQtlk8JeixnUuzl+XvBi7vsVyDOt15Rkc1OsqNUMVdk+y
         zbMLXsXPeKswYe891h0hAsDD862A3lxMUWcos=
MIME-Version: 1.0
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Date: Sat, 18 Apr 2009 12:57:23 +0900
Message-ID: <2f11576a0904172057x5a02cb9dlcd980d26126f8df4@mail.gmail.com>
Subject: Re: [GIT PATCH] driver core patches for 2.6.31-rc2
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/18 Greg KH <gregkh@suse.de>:
> Here are a few driver-core patches for your 2.6.31-rc2 tree.

2.6.30-rc2?

>
> The biggest patch here is the addition of the early platform driver api.
> This patch has been in the -mm tree for a few major kernel releases now
> (around 5 months), and there are a number of drivers pending in some of
> the arch trees that depend on this api being present.  It doesn't affect
> any x86 code, so the majority of the world will have no problems with
> this, and it all gets thrown away after init starts up, so it has no
> affect on memory sizes.
