Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZICS3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZICS3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZICS3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZICS3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:29:37 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com>
	<x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0909030926i35ee1b39l3f300426748974b5@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 Sep 2009 14:29:28 -0400
In-Reply-To: <4e5e476b0909030926i35ee1b39l3f300426748974b5@mail.gmail.com>
	(Corrado Zoccolo's message of "Thu, 3 Sep 2009 18:26:15 +0200")
Message-ID: <x49ocprx4on.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
>
>> How did you come to this magic number of 3, both for the number of
>> competing tasks and the multiplier for the slice time?  Did you
>> experiment with this number at all?
>
> The number is quickly explained. The base slice is 100ms, and on the
> mailing list it was mentioned that the latency becomes annoing for an
> user when it is above 300ms.  This means that, up to 3 processes, the
> current thresholds are good, and for more we have to scale.  This is
> good, because we don't change the behaviour unless we have many
> competing processes.

OK, then in your next patch, could you make this more clear?  Maybe
define a LATENCY_MAX and derive the number of processes from that,
instead of assuming that the base slice will always and forever be
100ms?

Cheers,
Jeff
