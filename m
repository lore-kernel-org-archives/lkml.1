Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbXIKPvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbXIKPvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXIKPvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:51:41 -0400
Received: from mailhub.linpro.no ([213.236.139.167]:34974 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXIKPvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:51:40 -0400
From: =?iso-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
To: mgross@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no>
	<20070911152323.GA17650@linux.intel.com>
Date: Tue, 11 Sep 2007 17:51:36 +0200
In-Reply-To: <20070911152323.GA17650@linux.intel.com> (Mark Gross's message of
	"Tue, 11 Sep 2007 08:23:23 -0700")
Message-ID: <ujr642h2oaf.fsf@false.linpro.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Gross <mgross@linux.intel.com> writes:
> Why not use NTP?

Because NTP is a completely different beast.  NTP is used to keep a
software clock synchronized with a remote source.  This software clock
is usually implemented as a software PLL on top of a high-resolution
hardware clock, with the remote clock serving as frequency reference.

What I need to do, however, is calibrate a low-resolution hardware
clock using a trusted reference (which could very well be a software
clock maintained by NTP).

DES
-- 
Dag-Erling Smørgrav
Senior Software Developer
Linpro AS - www.linpro.no
