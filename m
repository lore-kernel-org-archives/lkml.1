Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbXBCW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbXBCW4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 17:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXBCW4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 17:56:54 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:54689 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbXBCW4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 17:56:53 -0500
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Sun, 04 Feb 2007 09:56:42 +1100
Message-Id: <1170543402.23664.41.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-02-02 at 22:20 -0800, Christoph Lameter wrote:
> 1. We use the 21st page flag and we only have 20 on 32 bit NUMA platforms.

If it will help, I now have an implementation of the dynamically
allocated pageflags code I've posted in the past that is NUMA aware.
It's not memory hotplug aware yet, but that can be fixed. I can see if I
can find time this week to address that and send it to you if it will
help.

Regards,

Nigel

