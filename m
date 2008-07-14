Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYGNQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYGNQbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYGNQbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:31:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51592 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbYGNQbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:31:11 -0400
Subject: Re: [RFC PATCH 4/5] kmemtrace: SLUB hooks.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20080711231923.0f827113@linux360.ro>
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-3-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-4-git-send-email-eduard.munteanu@linux360.ro>
	 <20080710210617.70975aed@linux360.ro>
	 <84144f020807110145g3467d77md54e3d734ecba2c6@mail.gmail.com>
	 <20080711231923.0f827113@linux360.ro>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Jul 2008 19:30:54 +0300
Message-Id: <1216053054.6762.6.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Fri, 11 Jul 2008 11:45:59 +0300
> > Oh, I missed this on the first review. Here we have, like in SLOB,
> > page allocator pass-through, so wouldn't KIND_PAGES be more
> > appropriate?

﻿On Fri, 2008-07-11 at 23:19 +0300, Eduard - Gabriel Munteanu wrote:
> The rationale was to be able to trace how kmalloc()s perform, no matter
> what the allocator does behind the scenes. Presumably, the developer
> would know what kmalloc() really does with an allocation request.
> 
> Does this sound okay?

Fine with me.

		Pekka

