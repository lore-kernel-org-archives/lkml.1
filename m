Return-Path: <linux-kernel-owner+w=401wt.eu-S1763620AbXJXRCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763620AbXJXRCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763865AbXJXQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:52:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40921 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763852AbXJXQw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:52:57 -0400
Date: Wed, 24 Oct 2007 09:52:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@kernel.org>
cc: linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [2.6 patch] drivers/base/node.c: cleanups
In-Reply-To: <20071024162453.GQ30533@stusta.de>
Message-ID: <Pine.LNX.4.64.0710240948120.26032@schroedinger.engr.sgi.com>
References: <20071024162453.GQ30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Adrian Bunk wrote:

> This patch contains the following cleanups:
> - make the following needlessly globalcode static:
>   - register_node()
>   - node_state_attr[]
> - #if 0 the following unused global functions:
>   - unregister_node()
>   - unregister_one_node()

These may beneeded by the memory hotplug folks. Better leave them 
alone.
