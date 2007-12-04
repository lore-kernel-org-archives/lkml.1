Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbXLDVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbXLDVie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXLDViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:38:12 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:3675 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbXLDViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:38:09 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <linux.kernel@free.fr>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Is the PCI clock within the spec?
Date: Tue, 4 Dec 2007 13:37:31 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEPFIJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <47556E48.40703@free.fr>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 04 Dec 2007 13:38:48 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 04 Dec 2007 13:38:48 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > A scope probe will allow you to see if there is
> > a clock signal. That's all. You can't determine
> > its quality. A 4-inch ground lead on the scope
> > probe will result in 10-20% overshoot and undershoot
> > being observed.

> I don't understand this 10-20% figure.
> (0V + 10-20% is still 0V.)

If you're jumping from a 900 foot marker to a 910 foot marker, does a 10%
overshoot mean you jumped 1 foot too far or 90 feet too far? The percentage
is of the distance you were trying to go, not of where you started or where
you ended up.

> AFAIU, the nominal peak-to-peak voltage is 3.3V. The observed
> peak-to-peak voltage is 6.08V (3.3V + 84%).

So a 10% undershoot would mean that rather than going from 3.3V to 0V, you
overshot 0V by 10% or the distance you travelled. The voltages could just as
well be 100V and 103.3V, the transitions would still be the same. What you
call zero is, at least in principle, arbitrary.

DS


