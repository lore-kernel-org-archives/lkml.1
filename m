Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZA1QoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZA1QoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZA1Qn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:43:58 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:39961 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603AbZA1Qn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:43:57 -0500
Date: Wed, 28 Jan 2009 11:40:14 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: fix per cpu kmem_cache_cpu array memory leak
In-Reply-To: <1233134864.16201.3.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0901281139300.7765@qirst.com>
References: <alpine.DEB.2.00.0901271859010.17612@chino.kir.corp.google.com>  <1233132733.16201.0.camel@penberg-laptop>  <84144f020901280058h36fedf37j600185c255db5e2a@mail.gmail.com>  <alpine.DEB.2.00.0901280115470.28944@chino.kir.corp.google.com>
 <1233134864.16201.3.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Pekka Enberg wrote:

> The bug has been there for a very long time and hasn't generated any bug
> reports so I think I'll just push it to mainline and leave it that.

Typically we do not run out of elements of the per cpu array.

Note that this code can be removed if we finally get a per cpu allocator.

