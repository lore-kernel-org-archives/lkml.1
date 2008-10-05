Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYJEDUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYJEDUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 23:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYJEDUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 23:20:44 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35273 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbYJEDUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 23:20:43 -0400
Date: Sun, 5 Oct 2008 04:20:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11696] 2.6.27-rc8 doubled times
In-Reply-To: <yWwteD.A.itG.Y475IB@wind>
Message-ID: <Pine.LNX.4.64.0810050414260.27517@blonde.site>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.itG.Y475IB@wind>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11696
> Subject		: 2.6.27-rc8 doubled times
> Submitter	: Hugh Dickins <hugh@veritas.com>
> Date		: 2008-10-03 10:21 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=122302939313636&w=4
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> Patch		: http://marc.info/?l=linux-kernel&m=122307260621434&w=4

Can now be closed, thanks Rafael: Linus has taken Thomas's
commit 07454bfff151d2465ada809bbaddf3548cc1097c
clockevents: check broadcast tick device not the clock events device
and I've just confirmed that the latest git indeed fixes the issue.

Hugh
