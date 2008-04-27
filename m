Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYD0Gbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYD0Gbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYD0GbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:31:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:42598 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYD0GbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AnN3557xM9bZCbCqh+Ve5I4So0XGKriArrpOM6fqv978809++dyQ069nj/U+0UJVMZ1iZtLuCNThgviv/eAAmSKtG2cu+Ah63bzDJwNJvdNl4qsc22OG4RKfyPbQGwDTPLxRY4Q4KnrpnwoDJX9kHccQqkiOdDMYFvgF6GWsVac=
Subject: Re: [PATCH] asm/unaligned.h doesn't work well as the very first
	include
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080427061210.GT5882@ZenIV.linux.org.uk>
References: <20080427051918.GO5882@ZenIV.linux.org.uk>
	 <20080427060944.GB9199@uranus.ravnborg.org>
	 <20080427061210.GT5882@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 23:31:28 -0700
Message-Id: <1209277888.14173.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-27 at 07:12 +0100, Al Viro wrote:
> On Sun, Apr 27, 2008 at 08:09:44AM +0200, Sam Ravnborg wrote:
> 
> > It has been discussed that any .h file should pull
> > in what it needs so the other of includes does not matter.
> > Some do them alphabetically.
> 
> It has been discussed or it has been agreed?  IMO it's a bullshit - especially
> for low-level stuff like that.
> 
> As for the way some do includes...  It's not exactly a family-friendly list,
> but still I'd rather not comment in details on the existing practices...

I'm redoing the unaligned handling in -mm at the moment, and it avoids
this problem.

Harvey

