Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYCaGpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYCaGpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 02:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYCaGoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 02:44:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYCaGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 02:44:54 -0400
Date: Mon, 31 Mar 2008 08:48:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jack Steiner <steiner@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080331064833.GB29105@one.firstfloor.org>
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com> <20080326073823.GD3442@elte.hu> <86802c440803301323q5c4bd4f4k1f9bdc1d6b1a0a7b@mail.gmail.com> <20080330210356.GA13383@sgi.com> <20080330211848.GA29105@one.firstfloor.org> <86802c440803301629g6d1b896o27e12ef3c84ded2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803301629g6d1b896o27e12ef3c84ded2c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if the calling path like GET_APIC_ID is keeping checking if it is UV
> box after boot time, that may not good.

I don't think GET_APIC_ID is anywhere on a critical path. As long
as it doesn't lead to code bloat that shouldn't be an issue.

-Andi
