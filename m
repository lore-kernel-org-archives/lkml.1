Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXEJIh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXEJIh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXEJIhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:37:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbXEJIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:37:15 -0400
Date: Thu, 10 May 2007 01:36:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
       Lee.Schermerhorn@hp.com, apw@shadowen.org,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       jbarnes@virtuousgeek.org
Subject: Re: [Request-For-Test] [PATCH] change zonelist order v6 [0/3]
 Introduction
Message-Id: <20070510013619.7b8c2457.akpm@linux-foundation.org>
In-Reply-To: <20070510161611.fe1a696b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070510161611.fe1a696b.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:16:11 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This is zonelist-order-fix patch version 6. against 2.6.21-mm2.

This is new:

WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between '__build_all_zonelists' (at offset 0x3d13) and 'build_all_zonelists'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between '__build_all_zonelists' (at offset 0x3d2c) and 'build_all_zonelists'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between '__build_all_zonelists' (at offset 0x3d4b) and 'build_all_zonelists'

Using http://userweb.kernel.org/~akpm/config-sony.txt

Maybe it wasn't your match which did this, I didn't check.
