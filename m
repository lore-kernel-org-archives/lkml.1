Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYE1TUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYE1TUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYE1TUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:20:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYE1TUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:20:24 -0400
Date: Wed, 28 May 2008 15:17:56 -0400
From: Rik van Riel <riel@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTP: Let update_persistent_clock() sleep
Message-ID: <20080528151756.00869703@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 19:15:41 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  This is a change that makes the 11-minute RTC update be run in the
> process context.  This is so that update_persistent_clock() can sleep,
> which may be required for certain types of RTC hardware -- most notably
> I2C devices.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
