Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXAVTri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXAVTri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbXAVTri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:47:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbXAVTrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:47:37 -0500
Message-ID: <45B51369.1060408@redhat.com>
Date: Mon, 22 Jan 2007 14:41:29 -0500
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060803)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [-mm patch] drivers/firewire/: cleanups
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070122181736.GU9093@stusta.de>
In-Reply-To: <20070122181736.GU9093@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Jan 11, 2007 at 10:26:27PM -0800, Andrew Morton wrote:
>> ...
>> Changes since 2.6.20-rc3-mm1:
>> ...
>>  git-ieee1394.patch
>> ...
>>  git trees
>> ...
> 
> 
> This patch contains the following cleanups:
> - "extern inline" -> "static inline"

I guess that's fine, I do like how extern inline will never generate code and 
that gcc warns on missing prototype for these case is more of a gcc bug.  Not 
a big deal though, it's more worthwhile to track down real missing prototype 
offenders.

> - fw-topology.c: make struct fw_node_create static

Looks good.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>


