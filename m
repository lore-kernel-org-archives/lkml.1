Return-Path: <linux-kernel-owner+w=401wt.eu-S937969AbXHLWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937969AbXHLWpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763891AbXHLWpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:45:14 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39556 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763328AbXHLWpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:45:12 -0400
Date: Mon, 13 Aug 2007 07:44:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] 4KSTACKS, remove DEBUG_KERNEL dependency for sh
Message-ID: <20070812224411.GA23556@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200708122250.58773.jesper.juhl@gmail.com> <200708122253.24034.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708122253.24034.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:53:23PM +0200, Jesper Juhl wrote:
> 
> 4K Stacks is no longer a debug feature, so remove the DEBUG_KERNEL
> dependancy for 4KSTACKS for sh.
> 

While it may no longer be a debugging feature on i386, it certainly is on
sh. It should stay under DEBUG_KERNEL for now.
