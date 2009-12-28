Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZL1GaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZL1GaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 01:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZL1GaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 01:30:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57074 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZL1GaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 01:30:01 -0500
Message-ID: <4B385061.9060600@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 14:29:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/4] cgroups: revamp subsys array
References: <20091221203253.GA5683@andrew.cmu.edu> <20091221203515.GB5683@andrew.cmu.edu>
In-Reply-To: <20091221203515.GB5683@andrew.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Make subsys[] able to be dynamically populated to support modular subsystems
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This patch reworks the way the subsys[] array is used so that subsystems can
> register themselves after boot time, and enables the internals of cgroups to
> be able to handle when subsystems are not present or may appear/disappear.
> 
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

...

A small nitpick:

> +/* This define indicates the maximum number of subsystems that can be loaded
> + * at once. We limit to this many since cgroupfs_root has subsys_bits to keep
> + * track of all of them. */

Please always use this style:

/*
 * xxx
 * xxx
 */

