Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXLJKEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXLJKEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXLJKEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:04:00 -0500
Received: from styx.suse.cz ([82.119.242.94]:35048 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754857AbXLJKD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:03:58 -0500
Date: Mon, 10 Dec 2007 11:03:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH BUGFIX] hid: the `bit' in hidinput_mapping_quirks() is
 an	out parameter
In-Reply-To: <397037229.08913@ustc.edu.cn>
Message-ID: <Pine.LNX.4.64.0712101103350.4570@jikos.suse.cz>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
 <397037229.08913@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Fengguang Wu wrote:

> Fix a panic, by changing 
> 	hidinput_mapping_quirks(,, unsigned long *bit,)
> to 
> 	hidinput_mapping_quirks(,, unsigned long **bit,)
> The `bit' in this function is an out parameter.

Thanks for catching this, I will apply it to my tree.

-- 
Jiri Kosina
SUSE Labs
