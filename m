Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXEWWhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXEWWhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXEWWhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:37:35 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293AbXEWWhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:37:34 -0400
Date: Wed, 23 May 2007 15:37:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523153730.e0e9e91d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
	<20070523150122.f9946f37.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 15:27:28 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 23 May 2007, Andrew Morton wrote:
> 
> > argh, I never 100% understood the slab gobbledygook, and now we have slub
> > gobbledygook.  I _hope_ what that's saying is that the 00 at 0xc90f6d28
> > wasn't supposed to be there.
> 
> Exactly. I tried to make the SLUB gobbledygook better.

Actually now I look at it and work out what "b4" meant, it's not all that
gobbledygooky.  It's unclear what "Filler" means though.

> Any other ideas on 
> how to improve it?

A few words in slub.txt, perhaps?
