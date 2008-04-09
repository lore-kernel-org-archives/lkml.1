Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYDIABe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYDIABe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 20:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYDIABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 20:01:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36875 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYDIABY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 20:01:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #10326] inconsistent lock state in net_rx_action
Date: Wed, 9 Apr 2008 02:00:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, marcus@better.se
References: <SvnMeM-aZi.A.YKF.D__-HB@albercik> <20080408.165653.224963340.davem@davemloft.net>
In-Reply-To: <20080408.165653.224963340.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804090200.40396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of April 2008, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Wed,  9 Apr 2008 01:02:09 +0200 (CEST)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10326
> > Subject		: inconsistent lock state in net_rx_action
> > Submitter	: Marcus Better <marcus@better.se>
> > Date		: 2008-03-25 13:21 (15 days old)
> > Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10326#c20
> 
> This is already fixed by:
> 
> commit 50fd4407b8bfbde7c1a0bfe4f24de7df37164342
> Author: David S. Miller <davem@davemloft.net>
> Date:   Thu Mar 27 17:42:50 2008 -0700
> 
>     [NET]: Use local_irq_{save,restore}() in napi_complete().

Thanks, closed.

Rafael
