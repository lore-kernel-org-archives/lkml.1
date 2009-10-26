Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZJZPIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZJZPIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZJZPIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:08:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZJZPIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:08:50 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 3/5] cfq-iosched: reimplement priorities using  different service trees
References: <200910202012.12007.czoccolo@gmail.com>
	<x49eiow9202.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910210937y71d2018en2b8b4a23c4bb1aa1@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Oct 2009 11:08:48 -0400
In-Reply-To: <4e5e476b0910210937y71d2018en2b8b4a23c4bb1aa1@mail.gmail.com>
	(Corrado Zoccolo's message of "Wed, 21 Oct 2009 18:37:41 +0200")
Message-ID: <x491vkqyyyn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> On Wed, Oct 21, 2009 at 5:54 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>> + * Index in the service_trees.
>>> + * IDLE is handled separately, so it has negative index
>>> + */
>>> +enum wl_prio_t {
>>> +     IDLE_WORKLOAD = -1,
>>> +     BE_WORKLOAD = 0,
>>> +     RT_WORKLOAD = 1
>>> +};
>>
>> What's wrong with IOPRIO_CLASS_(RT|BE|IDLE)?  Why invent another enum?
> Because I want to index inside my internal structures, and I have no
> control over the former ones.

Well, I already know and understand IOPRIO*, and it seems like it maps
exactly to what you're doing.  I'll leave it up to Jens, though, this is
a minor detail.

Cheers,
Jeff
