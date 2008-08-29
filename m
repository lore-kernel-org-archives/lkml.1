Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYH2Pga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYH2Pga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYH2PgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:36:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYH2PgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:36:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Date: Fri, 29 Aug 2008 17:36:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
References: <20080829080549.6906b744@infradead.org> <20080829080809.0e42a323@infradead.org>
In-Reply-To: <20080829080809.0e42a323@infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291736.09400.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/awFnhnUfQrKBsX3V93Rhfv7tZtb4PrOke6oC
 nBkqWQjJ0hXTnVapN32Gg9sfxXz+tTxo+q0XtRzZACfPPox9fH
 a1sjA/8Q7q4RKNBygHjEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Arjan van de Ven wrote:
> This is only done for delays shorter than 1 second; currently
> the assumption is that longer delays have no desire to get the
> higher accuracy.

What is the tradeoff here? Where is the advantage in using the
traditional timer interface for longer timeouts?

	Arnd <><
