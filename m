Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbZFZOhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbZFZOhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFZOhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:37:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51361 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbZFZOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:37:42 -0400
Subject: Re: 2.6.31-rc1: parisc: multiple PCI BAR collisions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <a4423d670906260158q15080049ue516c3d454f4afbf@mail.gmail.com>
References: <a4423d670906260158q15080049ue516c3d454f4afbf@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 14:37:40 +0000
Message-Id: <1246027060.3925.18.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 12:58 +0400, Alexander Beregalov wrote:
> Hardware is HP j6000.
> It cannot initialize many PCI devices (sym53c8xx, tulip, STI,
> usb(onci)) and cannot boot (no root device).
> Messages like this:
> sym53c8xx 0:0:0f.0: device not available because of BAR 1 [0xf4005000
> - 0xf40053ff] collisions.

This tends to indicate a problem with resource parenting ... could you
post the full boot output?  That might indicate why.

James


