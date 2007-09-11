Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXIKQ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXIKQ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXIKQ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:28:14 -0400
Received: from mailhub.linpro.no ([213.236.139.167]:48829 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXIKQ2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:28:13 -0400
From: =?iso-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
To: mgross@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no>
	<20070911152323.GA17650@linux.intel.com>
Date: Tue, 11 Sep 2007 18:28:06 +0200
In-Reply-To: <20070911152323.GA17650@linux.intel.com> (Mark Gross's message of
	"Tue, 11 Sep 2007 08:23:23 -0700")
Message-ID: <ujrwsux1815.fsf@false.linpro.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Gross <mgross@linux.intel.com> writes:
> Is it necessary to change the rtc interface?  Can't you detect within
> your m48t59 driver that you are getting consistent time adjustments up
> or down from whats in the rtc and infer it needs speeding up or slowing
> down?

[I didn't notice this when I first replied]

Because of the RTC's low resolution and of how the calibration is
implemented in the chip, you need to sample the clock at intervals of
several hours in order to determine the direction of the required
adjustment.  Repeatedly setting the RTC to the correct time will
actually prevent correct calibration.

DES
-- 
Dag-Erling Smørgrav
Senior Software Developer
Linpro AS - www.linpro.no
