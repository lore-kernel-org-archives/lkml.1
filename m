Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbXGYKbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbXGYKbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbXGYKbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:31:11 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:11158 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbXGYKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:31:10 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Henri Hunnekens" <henrihunnekens@gmail.com>
Subject: Re: TSC calibration sometimes not correct with RT patch.
Date: Wed, 25 Jul 2007 12:30:23 +0200
User-Agent: KMail/1.9.7
cc: "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <e9f486400707250025k163d34cdk97cf2722db739634@mail.gmail.com>
 <20070725073949.GB595@elte.hu>
 <e9f486400707250056i7f6ef2aducef8c0f7cf11c09c@mail.gmail.com>
In-Reply-To: <e9f486400707250056i7f6ef2aducef8c0f7cf11c09c@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <200707251230.24311.joachim.deguara@amd.com>
X-OriginalArrivalTime: 25 Jul 2007 10:30:19.0999 (UTC)
 FILETIME=[CCD89EF0:01C7CEA6]
X-WSS-ID: 6AB9F9D17CS3229970-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 09:56:38 Henri Hunnekens wrote:
> Some more information, the problems occurs on a SMP machine. I've
> added the system logging which displays the CPU speed. The last line
> shows an inaccurate processor speed! I'll try an update, but I expect
> this has something to do with the TSC calibration and that hasn't
> changed, If I'm correct.

Could it just be that an SMI happened during the calibration?

-Joachim


