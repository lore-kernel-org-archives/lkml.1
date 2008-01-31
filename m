Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbYAaRJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbYAaRJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934311AbYAaRJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:09:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934303AbYAaRJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:09:01 -0500
Date: Thu, 31 Jan 2008 09:08:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, mingo@elte.hu,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: introduce /dev/mem restrictions with a config
 option
Message-ID: <20080131090839.7f610a6a@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0801311729190.4864@fbirervta.pbzchgretzou.qr>
References: <20080130124853.184ef782@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0801311729190.4864@fbirervta.pbzchgretzou.qr>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 17:53:04 +0100 (CET)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Jan 30 2008 12:48, Arjan van de Ven wrote:
> >Subject: [PATCH] x86: introduce /dev/mem restrictions with a config
> >option
> >
> >This patch introduces a restriction on /dev/mem: Only non-memory can
> >be read or written unless the newly introduced config option is set.
> 
> Would not it be nicer to add a /dev/pcimem that implements the given 
> restrictive semantics?
> 
> Maybe it's just wishful thinking, but I am dreaming of an
> unprivileged X, and /dev/pcimem (owned by an 'x11' user or so) would
> be a step in that direction.

/dev/pcimem is wrong; X can use the exact bar in sysfs already.
This is more for compatibility with legacy X


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
