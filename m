Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbYBRLw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbYBRLw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbYBRLwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:52:17 -0500
Received: from ns.suse.de ([195.135.220.2]:51502 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202AbYBRLwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:52:16 -0500
From: Andreas Schwab <schwab@suse.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, vatsa@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7] CGroup API: Update cpusets to use cgroup structured file API
References: <20080215204418.535025000@menage.corp.google.com>
	<20080215204821.778088000@menage.corp.google.com>
	<20080216212901.70fe35ce.pj@sgi.com> <47B9560F.3030402@cn.fujitsu.com>
	<47B96805.7070002@linux.vnet.ibm.com>
	<20080218111333.GA6333@balbir.in.ibm.com>
X-Yow: PUNK ROCK!!  DISCO DUCK!!  BIRTH CONTROL!!
Date: Mon, 18 Feb 2008 12:52:12 +0100
In-Reply-To: <20080218111333.GA6333@balbir.in.ibm.com> (Balbir Singh's message
	of "Mon\, 18 Feb 2008 16\:43\:33 +0530")
Message-ID: <jewsp24h3n.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh <balbir@linux.vnet.ibm.com> writes:

> @@ -238,7 +238,7 @@ rmdir() if there are no tasks.
>  The type of memory accounted by the cgroup can be limited to just
>  mapped pages by writing "1" to memory.control_type field
>  
> -echo -n 1 > memory.control_type
> +echo > memory.control_type

Looks like you stripped too much here.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
