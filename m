Return-Path: <linux-kernel-owner+w=401wt.eu-S1765041AbYDYTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765041AbYDYTb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYDYTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:31:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47695 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753996AbYDYTbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:31:52 -0400
Date: Fri, 25 Apr 2008 12:31:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Bryan Wu <cooloney@kernel.org>, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, Yi Li <yi.li@analog.com>,
       Christoph Lameter <christoph@lameter.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] [mm/slob] fix bug - when slob allocates "struct
 kmem_cache", it does not force alignment.
In-Reply-To: <1209139823.5323.5.camel@calx>
Message-ID: <Pine.LNX.4.64.0804251231180.6337@schroedinger.engr.sgi.com>
References: <1209121041-30524-1-git-send-email-cooloney@kernel.org>
 <1209139823.5323.5.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008, Matt Mackall wrote:

> Looks good, thanks. Christoph, do you want to take this or should it go
> through Andrew?

Pekka is handling the slab trees and it seems that he picked it up.
