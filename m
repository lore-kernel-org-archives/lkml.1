Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYJXAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYJXAOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYJXAOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:14:05 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:43726 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYJXAOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:14:05 -0400
Message-ID: <4901133B.6010404@tlinx.org>
Date: Thu, 23 Oct 2008 17:13:47 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
CC: david@fromorbit.com
Subject: Solved: Re: 2.6.27.[0,2] problems (v. 2.6.26.5): Samba & root-read-only
References: <48FED90F.7030809@tlinx.org> <20081022223005.GV18495@disturbed>
In-Reply-To: <20081022223005.GV18495@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*Double Bingo*...2.6.27.3 fixed both probs!      Thanks!!

Dave Chinner wrote:
> On Wed, Oct 22, 2008 at 12:41:03AM -0700, Linda Walsh wrote:
>
> Going to 2.6.27 (and just trying 2.6.27.2), two VERY weird problems.
>   1) Samba boot using the 2.6.27.2 kernel (or .0 before), I can no 
>      longer mount any file systems from my windows client. 
>   2) My root disk comes up READ-ONLY.  It uses XFS.
> ------
> That XFS problem should be fixed in 2.6.27.3,
>
> Most likely is that the Samba problem will be caused by the smbd
> not being able to write to it's databases when clients try
> to connect because of the read-only root fs.
>
> Dave.
>   

