Return-Path: <linux-kernel-owner+w=401wt.eu-S1760365AbZFKQgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365AbZFKQgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbZFKQfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:35:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbZFKQfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:35:54 -0400
Date: Thu, 11 Jun 2009 09:35:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] init: introduce mm_init()
In-Reply-To: <1244737869.6281.9.camel@penberg-laptop>
Message-ID: <alpine.LFD.2.01.0906110935160.3573@localhost.localdomain>
References: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906111157081.24376@gentwo.org> <1244737869.6281.9.camel@penberg-laptop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Pekka Enberg wrote:

> On Thu, 2009-06-11 at 11:57 -0400, Christoph Lameter wrote:
> > You forgot to move it to mm/mm_init.c
> 
> OK, but that needs to wait for another day. The patch series is already
> getting pretty big and there's no mminit.h in include/linux for this.

Yeah. Keep it in init/main.c for now. Let's keep it all simple.

		Linus
