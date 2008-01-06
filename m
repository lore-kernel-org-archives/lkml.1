Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYAFVjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYAFVjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYAFVi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:38:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42555 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbYAFViz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:38:55 -0500
Date: Sun, 6 Jan 2008 13:38:17 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, mpm@selenic.com
Subject: Re: [PATCH] Add bug/warn marker to generic report_bug()
Message-ID: <20080106133817.4f42ab82@laptopd505.fenrus.org>
In-Reply-To: <20080106202223.GA12640@lixom.net>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
	<20080106202223.GA12640@lixom.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 14:22:23 -0600
Olof Johansson <olof@lixom.net> wrote:

> Powerpc uses the generic report_bug() from lib/bug.c to report
> warnings, and I'm guessing other arches do as well.
> 
> Add the module list as well as the end-of-trace marker to the output.
> This required making print_oops_end_marker() nonstatic.
> 
> 

this is the wrong approach...
powerpc and such should just use oops_enter() / oops_exit() to signal the start/end of such 
a trace, that gives them all the other behavior of oopsing as well (such as the "slow oops scrolling down" etc)
