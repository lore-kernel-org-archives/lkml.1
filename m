Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbYEHLoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbYEHLoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYEHLoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:44:02 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:46822 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYEHLoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:44:01 -0400
To: Michael =?utf-8?Q?Elsd=C3=B6rfer?= <michael@elsdoerfer.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Cannot boot any HIGHMEM kernel (kernel panic - not syncing)
From: Andi Kleen <andi@firstfloor.org>
References: <4822DDF1.5010500@elsdoerfer.info>
Date: Thu, 08 May 2008 13:43:59 +0200
In-Reply-To: <4822DDF1.5010500@elsdoerfer.info> (Michael =?utf-8?Q?Elsd?=
 =?utf-8?Q?=C3=B6rfer's?= message of "Thu, 08 May 2008 13:03:13 +0200")
Message-ID: <87od7h9g1s.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 08 May 2008 11:37:01.0811 (UTC) FILETIME=[D514AC30:01C8B0FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Elsdörfer <michael@elsdoerfer.info> writes:
>
> Now, Machine Check Exception seems to point towards a hardware error,

It not only seems to, it does.

> but not only does the 486 kernel appear to work flawlessly, the server
> was perfectly happy running a self-compiled sarge kernel (with HIGHMEM)
> just a couple of days ago.

The non highmem kernel will simply not use most of your memory, so if 
the machine check happens accessing memory you will not see it.

-Andi
