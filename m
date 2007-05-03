Return-Path: <linux-kernel-owner+w=401wt.eu-S1161340AbXECQpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161340AbXECQpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162168AbXECQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:45:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33128 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161340AbXECQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:45:43 -0400
Date: Thu, 3 May 2007 09:45:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070503015729.7496edff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705030937290.8532@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
 <20070503011515.0d89082b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705030936120.5165@blonde.wat.veritas.com>
 <20070503015729.7496edff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmmm...There are a gazillion configs to choose from. It works fine with
cell_defconfig. If I switch to 2 processors I can enable SLUB if I switch 
to 4 I cannot.

I saw some other config weirdness like being unable to set SMP if SLOB is 
enabled with some configs. This should not work and does not work but 
the menus are then vanishing and one can still configure lots of 
processors while not having enabled SMP.

It works as far as I can tell... The rest is arch weirdness.


