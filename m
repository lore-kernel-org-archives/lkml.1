Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbYDXOSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbYDXOSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYDXOSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:18:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37940
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbYDXOSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:18:35 -0400
Date: Thu, 24 Apr 2008 07:18:35 -0700 (PDT)
Message-Id: <20080424.071835.06112189.davem@davemloft.net>
To: mb@bu3sch.de
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804241606.00883.mb@bu3sch.de>
References: <200804232055.13102.mb@bu3sch.de>
	<87mynjgyg9.fsf@basil.nowhere.org>
	<200804241606.00883.mb@bu3sch.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Buesch <mb@bu3sch.de>
Date: Thu, 24 Apr 2008 16:06:00 +0200

> Why do we need to workaround this in _every_ driver? (Note that _every_
> driver supporting a 64bit mask is affected). Why not fix it in the DMA layer?

Because the driver has to make a conscious choice of what
DMA mask it wants to use.  Datastructures can change based
upon whether 32-bit or 64-bit DMA is available, etc.

