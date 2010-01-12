Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0ALQ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0ALQ2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520Ab0ALQ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:28:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0ALQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:28:28 -0500
Date: Tue, 12 Jan 2010 17:28:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 pagemap endless read loop
Message-ID: <20100112162823.GC7363@basil.fritz.box>
References: <20100110020955.GB25323@basil.fritz.box> <20100110063335.GA3005@hack> <20100110123702.GC25323@basil.fritz.box> <20100112153208.GF3925@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112153208.GF3925@hack>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, could you please try:
> 
>      time cat /proc/self/pagemap >/dev/null
> 

I stopped it after a minute of CPU time...

Obviously reading 47bits of zeroes take a long time.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
