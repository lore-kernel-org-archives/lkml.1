Return-Path: <linux-kernel-owner+w=401wt.eu-S1765352AbYBZUva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765352AbYBZUva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbYBZUvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:51:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45115
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYBZUvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:51:22 -0500
Date: Tue, 26 Feb 2008 12:52:07 -0800 (PST)
Message-Id: <20080226.125207.203507844.davem@davemloft.net>
To: mitov@issp.bas.bg
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802260134.02075.mitov@issp.bas.bg>
References: <8A71B368A89016469F72CD08050AD334026D652F@maui.asicdesigners.com>
	<47C34838.3040502@garzik.org>
	<200802260134.02075.mitov@issp.bas.bg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marin Mitov <mitov@issp.bas.bg>
Date: Tue, 26 Feb 2008 01:34:01 +0200

> On Tuesday 26 February 2008 12:59:04 am you wrote:
> > Divy Le Ray wrote:
> > >> From: "Divy Le Ray" <divy@chelsio.com>
> > >> Date: Wed, 20 Feb 2008 21:57:08 -0800
> > >>
> > >>> The driver is cxgb3 here, it uses LLTX.
> > >>
> > >> That's extremely unfortunate, hopefully you can update it to
> > >> use a model like tg3 and others use.  LLTX is a lost cause
> > >> for hardware device drivers, and in fact we'd like to remove
> > >> it tree wide eventually.
> 
> Just for info: loopback.c uses it too :-)

I know, as I said: "for hardware device drivers" it's a lost
cause.  Loopback is a software device.

