Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbZCPQU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbZCPQU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZCPQUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:20:50 -0400
Received: from gw.goop.org ([64.81.55.164]:58993 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbZCPQUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:20:50 -0400
Message-ID: <49BE7C57.6060100@goop.org>
Date: Mon, 16 Mar 2009 09:20:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Sergio Luis <eeeesti@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: asm doubt
References: <ce0170d90903150716t14033a9dr3b3bf028933dde7c@mail.gmail.com> <49BD2FC7.5050903@goop.org> <49BE5E4E.1070209@redhat.com>
In-Reply-To: <49BE5E4E.1070209@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jeremy Fitzhardinge wrote:
>> In 32-bit mode, moving to a segment register can fault if the 
>> underlying GDT/LDT entry is invalid.  In 64-bit mode, segment 
>> registers are mostly decorative and have no function, and moving 
>> arbitrary values into them doesn't fault, making the exception 
>> catching unnecessary.
>
> 64-bit mode will in fact fault if an access is made outside the 
> GDT/LDT, or of the descriptor is invalid.

Oh, I didn't think it bothered.  I guess I'm conflating that with the 
fact that it doesn't apply any of the segment properties to memory 
accesses.  Anyway, in that case the 64-bit code should definitely be 
using the standard segment accessors.

    J

