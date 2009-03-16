Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbZCPON0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbZCPON0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbZCPONO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:13:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447AbZCPONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:13:12 -0400
Message-ID: <49BE5E4E.1070209@redhat.com>
Date: Mon, 16 Mar 2009 16:12:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sergio Luis <eeeesti@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: asm doubt
References: <ce0170d90903150716t14033a9dr3b3bf028933dde7c@mail.gmail.com> <49BD2FC7.5050903@goop.org>
In-Reply-To: <49BD2FC7.5050903@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> In 32-bit mode, moving to a segment register can fault if the 
> underlying GDT/LDT entry is invalid.  In 64-bit mode, segment 
> registers are mostly decorative and have no function, and moving 
> arbitrary values into them doesn't fault, making the exception 
> catching unnecessary.

64-bit mode will in fact fault if an access is made outside the GDT/LDT, 
or of the descriptor is invalid.


-- 
error compiling committee.c: too many arguments to function

