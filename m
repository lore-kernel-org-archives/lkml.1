Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYEOR3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYEOR3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYEOR3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:29:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35495 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750758AbYEOR3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:29:17 -0400
Date: Thu, 15 May 2008 10:29:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slub: record page flag overlays explicitly
In-Reply-To: <1210871999.0@pinky>
Message-ID: <Pine.LNX.4.64.0805151028130.18354@schroedinger.engr.sgi.com>
References: <exportbomb.1210871946@pinky> <1210871999.0@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Andy Whitcroft wrote:
 
> SLUB reuses two page bits for internal purposes, it overlays PG_active
> and PG_error.  This is hidden away in slub.c.  Document these overlays
> explicitly in the main page-flags enum along with all the others.

Hmmm.. Add the definitions also to page-flags.h?

SLABFLAG(Frozen, PG_active)
SLABFLAG(Debug, PG_error)
?

