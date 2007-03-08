Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXCHUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXCHUPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXCHUPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:15:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57364 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752640AbXCHUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:15:42 -0500
From: Pat Gefre <pfg@sgi.com>
Message-Id: <200703082015.l28KFchD258554@fsgi900.americas.sgi.com>
Subject: Re: [PATCH] 2.6 Altix : console fix for CONFIG_DEBUG_SHIRQ usage
To: akpm@linux-foundation.org (Andrew Morton)
Date: Thu, 8 Mar 2007 14:15:38 -0600 (CST)
Cc: pfg@sgi.com (Pat Gefre), linux-kernel@vger.kernel.org
In-Reply-To: <20070307143809.f103944f.akpm@linux-foundation.org> from "Andrew Morton" at Mar 07, 2007 02:38:09 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

+ 
+ On Wed, 7 Mar 2007 15:57:07 -0600 (CST)
+ Pat Gefre <pfg@sgi.com> wrote:
+ 
+ > The sn console driver was snagged by the use of CONFIG_DEBUG_SHIRQ !
+ > 
+ > The request_irq() immediate call to the interrupt handler caused
+ > another attempt to lock the port lock - deadlock.
+ > 
+ > This is a patch to fix that.
+ 
+ Should this go into 2.6.20.x as well?
+ 

Sure. I don't see why not.


-- Pat
