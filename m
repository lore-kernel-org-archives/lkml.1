Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXLROtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXLROtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXLROtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:49:05 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51171 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbXLROtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:49:04 -0500
Date: Tue, 18 Dec 2007 15:49:02 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Chinner <dgc@sgi.com>
cc: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Do not reset xfsquota flags on quotaless ro mount
In-Reply-To: <20071218143849.GP4396912@sgi.com>
Message-ID: <Pine.LNX.4.64.0712181547090.32270@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712181459210.32270@fbirervta.pbzchgretzou.qr>
 <20071218143849.GP4396912@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19 2007 01:38, David Chinner wrote:
>> 
>> In https://bugzilla.novell.com/show_bug.cgi?id=345338 it is
>> claimed that resetting the quota flags in the mounting sequence
>> rw,ro,rw is a bug, but I would say this is not the case,
>
>You mounted without quotas in the middle step, thereby invalidating
>them.
>
That's clear to me, but according to the commenter, the filesystem is
in read-only mode (that is, if no recovery was necessary for the ro
mount), hence they should not be invalidated as they cannot change
anyway. Or can they?

