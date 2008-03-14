Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYCNPpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYCNPpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYCNPpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:45:12 -0400
Received: from gw.goop.org ([64.81.55.164]:43576 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYCNPpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:45:10 -0400
Message-ID: <47DA9D0E.8080304@goop.org>
Date: Fri, 14 Mar 2008 08:43:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify sync_test_bit()
References: <47DA3DC0.76E4.0078.0@novell.com> <47DA93D0.4050708@goop.org> <47DAA5C2.76E4.0078.0@novell.com>
In-Reply-To: <47DAA5C2.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> I'm usually intentionally using just the names, without parameters and
> not as inline, in such alias definitions so that in case the name gets used
> as a function pointer (arguably unlikely here) there's not going to be
> any missing definition or duplicate function instantiation. But from a
> functionality point of view, either of the alternatives you suggest is
> of course as good.

I'm especially wary of the naked #define, since it will affect any 
instance of sync_test_bit:

struct bit_thingy {
	unsigned sync_test_bit:1;
	unsigned other_test_bit:1;
	...
};

J
