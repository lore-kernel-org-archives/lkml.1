Return-Path: <linux-kernel-owner+w=401wt.eu-S1030269AbXCLOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269AbXCLOp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030220AbXCLOp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:45:28 -0400
Received: from gw.goop.org ([64.81.55.164]:46449 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030263AbXCLOp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:45:27 -0400
Message-ID: <45F56785.5070002@goop.org>
Date: Mon, 12 Mar 2007 07:45:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: _proxy_pda still makes linking modules fail
References: <1173315479.12472.9.camel@qrnik> <p73lki39s3a.fsf@bingen.suse.de> <45F49E0A.3090607@goop.org> <20070312094805.GA11644@one.firstfloor.org>
In-Reply-To: <20070312094805.GA11644@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Rusty's pda->per_cpu patch will deal with this once and for all; have
>>     
>
> Not on x86-64.
>   

Have you considered dropping pda in x86-64?  Segment based percpu
doesn't really have any disadvantages.

>> you picked it up yet?
>>     
>
> Not yet.
>   

There will be interactions with my paravirt+xen patches, so I'm
wondering if I should rebase onto those patches, or should we apply them
later and fix everything up?


    J
