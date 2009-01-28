Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZA1J15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZA1J15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZA1J1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:27:47 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37709 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZA1J1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:27:47 -0500
Subject: Re: [patch] slub: fix per cpu kmem_cache_cpu array memory leak
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0901280115470.28944@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0901271859010.17612@chino.kir.corp.google.com>
	 <1233132733.16201.0.camel@penberg-laptop>
	 <84144f020901280058h36fedf37j600185c255db5e2a@mail.gmail.com>
	 <alpine.DEB.2.00.0901280115470.28944@chino.kir.corp.google.com>
Date: Wed, 28 Jan 2009 11:27:44 +0200
Message-Id: <1233134864.16201.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 28 Jan 2009, Pekka Enberg wrote:
> > Btw, did you hit this bug during testing or did you just spot it
> > during review? That is, do we need to get this to -stable? 

On Wed, 2009-01-28 at 01:20 -0800, David Rientjes wrote:
> I ran into it while hacking the per cpu arrays, but haven't witnessed it 
> on a vanilla kernel.  Since there are no guarantees that a kmem_cache_cpu 
> will not be allocated on this boundary, I would recommend it for -stable.

Documentation/stable_kernel_rules.txt states that:

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).

The bug has been there for a very long time and hasn't generated any bug
reports so I think I'll just push it to mainline and leave it that. 

Thanks!

		Pekka

