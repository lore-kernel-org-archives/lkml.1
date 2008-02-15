Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbYBOMpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbYBOMpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYBOMpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:45:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41554 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYBOMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:45:43 -0500
Subject: Re: 2.6.24-mm1 bugs
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdike@addtoit.com,
       jack@suse.cz
In-Reply-To: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 13:45:37 +0100
Message-Id: <1203079537.6855.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 12:43 +0100, Miklos Szeredi wrote:

>  - strange key repeating (short press of a key results in lots of key
>    press events) when there's some sort of load (I/O?)  I may have
>    seen this on non-mm kernels as well, but it's definitely more
>    noticable in -mm

Do you have CONFIG_FAIR_GROUP_SCHED enabled?, if so, does disabling it
make it go away?

