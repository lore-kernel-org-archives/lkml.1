Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbYGQUO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbYGQUO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759937AbYGQUOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:14:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33649 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781AbYGQUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:14:18 -0400
Message-ID: <487FA816.6070208@firstfloor.org>
Date: Thu, 17 Jul 2008 22:14:14 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
References: <20080716214516.GA10777@basil.nowhere.org>  <200807170011.12184.rjw@sisk.pl>  <200807161633.01375.jbarnes@virtuousgeek.org>  <487EEAEB.4050009@firstfloor.org>  <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>  <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>  <487F71E8.9050705@firstfloor.org> <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com> <487FA24B.9060803@firstfloor.org> <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 17 Jul 2008, Andi Kleen wrote:
>> The whole point of the exercise of cleaning up/rewriting the history is to make
>> the tree as bisectable as possible.
> 
> No.
> 
> "git bisect" is perfetly able to handle merges. They are _fine_.

The issue I worry about is it hitting between changes and their fixup.

e.g. for example if I find that specific change doesn't compile in some special
configuration then I amend it to fix that. Alternatively I could put in a fixup
commit  afterwards, but then if someone did bisect and the bisect hit inbetween
the change and the fixup they might end up with a tree that doesn't compile.

-Andi
