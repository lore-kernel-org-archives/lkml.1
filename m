Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYGNRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYGNRXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYGNRXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:23:38 -0400
Received: from [194.117.236.238] ([194.117.236.238]:42924 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYGNRXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:23:37 -0400
Date: Mon, 14 Jul 2008 20:21:02 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] kmemtrace: SLAB hooks.
Message-ID: <20080714202102.4e2ce7b6@linux360.ro>
In-Reply-To: <487B7F99.4060004@linux-foundation.org>
References: <84144f020807110149v4806404fjdb9c3e4af3cfdb70@mail.gmail.com>
	<1215889471-5734-1-git-send-email-eduard.munteanu@linux360.ro>
	<1216052893.6762.3.camel@penberg-laptop>
	<487B7F99.4060004@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 11:32:25 -0500
Christoph Lameter <cl@linux-foundation.org> wrote:
 
> > Looks as if the function calls itself ﻿recursively?
> > 
> 
> Code not tested? Are you sure you configured for slab?

This was a stupid typo on my part. I tested, but only with
CONFIG_KMEMTRACE, which took the 'extern' ifdef branch. I'll resubmit
in a few minutes.
