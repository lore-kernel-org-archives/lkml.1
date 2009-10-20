Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZJTWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZJTWZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 18:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZJTWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 18:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZJTWZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 18:25:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Zubin Dittia <zubin@tintri.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libaio asynchronous syscall io_getevents blocks on error
References: <47c554d90910201458of5dc16eg33940584026bc959@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 20 Oct 2009 18:25:09 -0400
In-Reply-To: <47c554d90910201458of5dc16eg33940584026bc959@mail.gmail.com>
	(Zubin Dittia's message of "Tue, 20 Oct 2009 14:58:17 -0700")
Message-ID: <x49ljj5og8q.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zubin Dittia <zubin@tintri.com> writes:

> I'm writing a program that uses the kernel's io_submit/io_getevents
> system calls.  What I would like to be able to do is submit N
> operations for i/o on different files, and then call io_getevents with
> min_nr = nr = N and a timeout of NULL, so that I can block until all N
> operations have completed.  This works great, except when one of the
> operations has an error (eg., if one of the descriptors is invalid).
> In this case, the call to io_getevents appears to block indefinitely.
> Shouldn't an error on one of the submitted operations count as a
> completion event for that operation, so I can check the error code
> when the call returns?  Any help would be appreciated.

Did you check the return value of io_submit?

Cheers,
Jeff
