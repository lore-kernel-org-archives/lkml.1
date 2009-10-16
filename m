Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZJPQ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZJPQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZJPQ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:58:15 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43757 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751062AbZJPQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:58:15 -0400
Date: Fri, 16 Oct 2009 12:50:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
In-Reply-To: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0910161249100.6120@gentwo.org>
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So writing to any file clears all counters? The documentation does not say
so.

Would it not be better to have an explicit sysfs file for clearing. The
patch would be smaller and the api better.

