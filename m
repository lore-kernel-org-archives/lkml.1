Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYE3I3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYE3I3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYE3I3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:29:36 -0400
Received: from smtp.movial.fi ([62.236.91.34]:44470 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbYE3I3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:29:35 -0400
Message-ID: <483FB3C1.9070309@movial.fi>
Date: Fri, 30 May 2008 10:58:57 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.8 (X11/20061208)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] [MIPS] The tickcount per-cpu variable can become
 static
References: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi> <12120730321843-git-send-email-dmitri.vorobiev@movial.fi>
In-Reply-To: <12120730321843-git-send-email-dmitri.vorobiev@movial.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev wrote:
> In arch/mips/mips-boards/generic/time.c, the `tickcount' per-cpu
> variable is needlessly defined global, and this patch makes it
> static.
> 
> Noticed by sparse. Tested by booting a Qemu-emulated Malta board
> up to the shell prompt.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

Ouch, it seems that this one does not apply to the latest linux-mips 
git. I usually base my patches on Linus' tree. Please drop.

Dmitri

