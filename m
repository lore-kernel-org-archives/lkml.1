Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXH1Qqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXH1Qqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbXH1QqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:46:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44371 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979AbXH1QqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:46:20 -0400
Date: Tue, 28 Aug 2007 09:45:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Clemens Kolbitsch <clemens.kol@gmx.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: user-mode stack size & location
Message-ID: <20070828094548.34186c0c@laptopd505.fenrus.org>
In-Reply-To: <200708281825.01688.clemens.kol@gmx.at>
References: <200708281825.01688.clemens.kol@gmx.at>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 18:25:01 +0200
Clemens Kolbitsch <clemens.kol@gmx.at> wrote:
> i see that the aout-, elf-, etc. handlers all set this variable -->
> is this the only location where it can be set?
> 
> 2.) when looking at /proc/PID/maps, i see that the stack always ends
> at different locations (obviously close to TASK_SIZE). thus the sizes
> seem to vary. where are they set / where are the infos written to the
> vma's / the PGD?
> 
> any help would be greatly appreciated!!
\

hi,

if you look where arch_align_stack() gets called.. that's where you
want to look. arch_align_stack() gets invoked in code that selects
userspace stack pointers....

Greetings,
   Arjan van de Ven
