Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbXCUSSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbXCUSSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbXCUSSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:18:17 -0400
Received: from saeurebad.de ([85.214.36.134]:37828 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbXCUSRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:17:55 -0400
Date: Wed, 21 Mar 2007 19:17:40 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Wink Saville <wink@saville.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Initial implementation of the trec driver and include files
Message-ID: <20070321181739.GC16768@leiferikson>
Mail-Followup-To: Wink Saville <wink@saville.com>,
	linux-kernel@vger.kernel.org
References: <d4cf37a60703202347o67740694jc1c9030c647ff7c6@mail.gmail.com> <20070321082238.GA16768@leiferikson> <46016208.3040303@saville.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46016208.3040303@saville.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 21, 2007 at 09:49:12AM -0700, Wink Saville wrote:
> >>Please don't use camel-case - in general.
> >>    
> Would p_next, p_cur and p_end be OK?

I think it's generally disliked. Quoting Documentation/CodingStyle:

``Encoding the type of a function into the name (so-called Hungarian
notation) is brain damaged - the compiler knows the types anyway and can
check those, and it only confuses the programmer.  No wonder MicroSoft
makes buggy programs.''

> >>--- /dev/null
> >>+++ b/include/linux/trec.h
> >>@@ -0,0 +1,34 @@
> >>+/*
> >>+#define TREC0()			trec_write(TREC_PC_ADDR, TREC_PID, 
> >>0, 0)
> >>    
> [...]
> >>+
> >>+#define ZREC0()			do { } while (0)
> >>    
> >Why not seperate them by an #ifndef? So you don't have to replace TREC?
> >with ZREC? but rather change one #define knob.
> 
> The reason is to allow the user easily change individual TREC's from 
> active to inactive by just
> changing a single character. Eventually I envision adding runtime 
> support for changing if a
> particular set of TREC's are active or not, but this was simple.

You can implement a sysctl-setting to enable/disable the whole system
(which then would be runtime changeable).

=Hannes
