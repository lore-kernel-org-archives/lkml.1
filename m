Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYFXFwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYFXFwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYFXFwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:52:37 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:31024 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbYFXFwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:52:36 -0400
Date: Tue, 24 Jun 2008 14:50:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: fix seq_file memory leak
Message-ID: <20080624055009.GA22890@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Li Zefan <lizf@cn.fujitsu.com>, linux-sh@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <4860866F.7050703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4860866F.7050703@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 01:30:23PM +0800, Li Zefan wrote:
> When using single_open(), single_release() should be used instead
> of seq_release(), otherwise there is a memory leak.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Good catch. Applied, thanks.
