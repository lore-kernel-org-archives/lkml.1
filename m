Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZHFVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZHFVlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZHFVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:41:15 -0400
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:41756 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756379AbZHFVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:41:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=q2oWzLJya1+AikLPju1WSmylqnqYzMv8HpF0TlBnkdz2fhoNDP05EquyVYNoV+VQAVRLEUaKaE7SZxT7mB9CsRWWlk4MgX8WHr8Uppz26eD4jVnOi6RAyWenbHrqIird;
Date: Thu, 6 Aug 2009 14:41:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Frans Pop <elendil@planet.nl>
Cc: David John <davidjon@xenontk.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: Re: [PATCH v2] Remove Spurious PnP Memory Reserved Warning
Message-ID: <20090806144112.77752665@jbarnes-g45>
In-Reply-To: <200908011256.11628.elendil@planet.nl>
References: <1248505976-4952-1-BlackWidow-davidjon@xenontk.org>
	<1248753983-4334-1-BlackWidow-davidjon@xenontk.org>
	<20090728093137.52575d8c@jbarnes-g45>
	<200908011256.11628.elendil@planet.nl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Aug 2009 12:56:10 +0200
Frans Pop <elendil@planet.nl> wrote:

> On Tuesday 28 July 2009, Jesse Barnes wrote:
> > I'm inclined to keep the message, since it's just a dev_info and
> > does provide interesting info sometimes.  So unless Linus wants to
> > kill it...
> 
> Jesse, what do you think of the less invasive patch I suggested in 
> http://lkml.org/lkml/2009/7/24/16?

I like it a bit better since it preserves the info in the case where a
resource was already reserved, so I'm fine if it goes upstream.  We're
just talking about debug info here so most users shouldn't notice
either unless there's a real problem.

-- 
Jesse Barnes, Intel Open Source Technology Center
