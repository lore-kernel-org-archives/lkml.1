Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXKOHyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXKOHyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXKOHyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:54:46 -0500
Received: from usul.saidi.cx ([204.11.33.34]:36769 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752186AbXKOHyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:54:46 -0500
Message-ID: <473BFB3D.1060802@overt.org>
Date: Wed, 14 Nov 2007 23:54:37 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: powernow-k8 and non-standard multipliers
References: <47393521.6060207@overt.org> <1449F58C868D8D4E9C72945771150BDF020770FF@SAUSEXMB1.amd.com>
In-Reply-To: <1449F58C868D8D4E9C72945771150BDF020770FF@SAUSEXMB1.amd.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Langsdorf, Mark wrote:
> 
> The standard PowerNow! driver, by design, will stop 
> working in this situation.  I'm not going to support
> a driver that allows non-standard multipliers because
> it could cause a lot of hard to debug maintenance
> issues.

Just a follow-up to get this into the public record. I
discussed this with Mark privately and then did more
digging and established that in my particular case, the
problem was that the BIOS was hiding the p-state table
when a non-standard multiplier was used. So, I built
a custom DSDT that included the p-state table along
with an extra entry for my higher speed and now I've
happily got powernow support again.

--phil
