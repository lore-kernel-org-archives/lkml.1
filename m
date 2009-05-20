Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbZETPeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbZETPeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZETPeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:34:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4497 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZETPeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:34:09 -0400
Subject: Re: [PATCH] mm/slub.c: change printk()s to pr_*() notation
From: Joe Perches <joe@perches.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <84144f020905200533j2e1debc1i97e0dbb96ef0edf6@mail.gmail.com>
References: <200905191103.03749.hartleys@visionengravers.com>
	 <84144f020905200533j2e1debc1i97e0dbb96ef0edf6@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 08:34:03 -0700
Message-Id: <1242833643.22786.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 15:33 +0300, Pekka Enberg wrote:
> On Tue, May 19, 2009 at 9:03 PM, H Hartley Sweeten
> Hmm, isn't the whole point of pr_err() that you override pr_fmt() to
> include your subsystem name?

I think the subsystem name should (eventually) be taken
automatically from KBUILD_MODNAME

