Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZBDPkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZBDPkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZBDPko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:40:44 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:48739 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752269AbZBDPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:40:44 -0500
Date: Wed, 4 Feb 2009 10:34:13 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Swamy Gowda <swamy@virident.com>, linux-kernel@vger.kernel.org,
       Brice.Goglin@inria.fr
Subject: Re: Need to take mmap_sem lock in move_pages.
In-Reply-To: <20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0902041033370.19633@qirst.com>
References: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info> <20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com> <20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, KAMEZAWA Hiroyuki wrote:

> >  1. do_move_page_to_node_array() at el. needs mmap_sem (read-side) because it
> >     scans page table and vma. While we have to scan vmas to find pages for
> >     migration, it needs mmap_sem.

Right.

