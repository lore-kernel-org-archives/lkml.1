Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbXGFRF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbXGFRF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757785AbXGFRFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:05:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36158 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbXGFRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:05:15 -0400
Date: Fri, 6 Jul 2007 19:05:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Gautam Singaraju <gautam.singaraju@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: syscall macro fails upon compilation
Message-ID: <20070706170512.GA8174@one.firstfloor.org>
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com> <468D6D1F.4040008@zytor.com> <p73r6nl21fe.fsf@bingen.suse.de> <468E699C.1000502@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468E699C.1000502@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> They were *always* broken for 64-bit arguments on 32-bit machines, however.

Well syscall() doesn't support that at all (unless you split by hand)

-Andi
