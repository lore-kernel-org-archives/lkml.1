Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbYDVW0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbYDVW0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762957AbYDVWZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:25:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:37788 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762792AbYDVWZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:25:17 -0400
Subject: Re: [PATCH 3/3] atyfb: Fix 64 bits resources on 32 bits archs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
In-Reply-To: <480E07BC.3050107@ru.mvista.com>
References: <20080422012726.42775DE2A3@ozlabs.org>
	 <480E07BC.3050107@ru.mvista.com>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 08:20:06 +1000
Message-Id: <1208902806.9640.136.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 19:43 +0400, Sergei Shtylyov wrote:
>     Not sure what that change gives us -- this function mostly treats 'addr' 
> as unsigned long (casting it to char/void *), ot compares it to 'unsigned 
> long' 'base' variable -- which should be made 'resource_size_t' in its turn 
> being assigned resource's start value.  So, this part of patch looks incomplete
> (and yet I'm not sure if SPARC really needs all that)...

I just wanted to make sure both setup functions has the same prototype. 

I think sparc doesn't need fixing in there.

Ben.

