Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab0BGSa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 13:30:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:37374 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab0BGSaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 13:30:55 -0500
Date: Sun, 7 Feb 2010 10:32:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 - cpu_relax - why nop vs. pause?
Message-ID: <20100207103208.4e2ecfb4@infradead.org>
In-Reply-To: <4B6EF853.9090704@majjas.com>
References: <4B6EF853.9090704@majjas.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Feb 2010 12:28:51 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> I did search and noticed some old discussions. Looking at both Intel
> and AMD documentation, it would seem that PAUSE is the preferred
> instruction within a spin lock. Further, both Intel and AMD
> specifications state that the instruction is backward compatible with
> older x86 processors.
> 

that's odd....

rep nop and pause ought to be the same...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
