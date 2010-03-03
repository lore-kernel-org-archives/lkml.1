Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0CCMos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:44:48 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:48303 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab0CCMor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:44:47 -0500
X-AuditID: c1b4fb39-b7c2dae000007b99-3c-4b8e59bd22a4
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] rtc-coh901331: Fix braces in resume code.
Date: Wed, 3 Mar 2010 13:44:41 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E9EE76C@eseldmw101.eemea.ericsson.se>
In-Reply-To: <6a4b170b1003030355p44dd277fpedae0da7a76ed739@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] rtc-coh901331: Fix braces in resume code.
Thread-Index: Acq6yGUss0KaVJ1HTD6H+mFBPaknaQABsuXg
References: <6a4b170b1003030355p44dd277fpedae0da7a76ed739@mail.gmail.com>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "James Hogan" <james@albanarts.com>,
       "Alessandro Zummo" <a.zummo@towertech.it>,
       "Paul Gortmaker" <p_gortmaker@yahoo.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Russell King" <rmk+kernel@arm.linux.org.uk>,
       <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Mar 2010 12:44:45.0223 (UTC) FILETIME=[4D5A2370:01CABACF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[James]
> The else part of the if statement is indented but does not have braces
> around it. It clearly should since it uses clk_enable and clk_disable
> which are supposed to balance.
> 
> Signed-off-by: James Hogan <james@albanarts.com>

OMG, thanks for spotting this!
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
