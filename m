Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZBADFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZBADFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 22:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZBADFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 22:05:13 -0500
Received: from main.gmane.org ([80.91.229.2]:49018 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbZBADFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 22:05:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bryon Roche <kain@kain.org>
Subject: Please disregard Re: 2.6.27.8 (+?) softlockup BUG (inotify still
 raceable)?
Date: Sun, 1 Feb 2009 03:00:42 +0000 (UTC)
Message-ID: <gm338q$m3p$2@ger.gmane.org>
References: <gm32qh$m3p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p548a7326.dip.t-dialin.net
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Feb 2009 02:53:06 +0000, Bryon Roche wrote:

> Hello all, I think i've hit another race BUG in inotify causing soft
> lockup on a heavily loaded system.  Amusingly enough, the only actual
> user of inotify in this case on said system is console-kit-daemon which
> has since been expunged.

Sorry, just found the earlier mention of the lib/idr.c fix that probably 
touches this.

Cheers
/B

