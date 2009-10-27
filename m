Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZJ0BQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZJ0BQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbZJ0BQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:16:48 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42486 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbZJ0BQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <7v8wexd6zq.fsf@alter.siamese.dyndns.org>
References: <1256602127.29938.8.camel@Joe-Laptop.home> <7v8wexd6zq.fsf@alter.siamese.dyndns.org>
From: Marti Raudsepp <marti@juffo.org>
Date: Tue, 27 Oct 2009 03:16:31 +0200
Message-ID: <54b33ccd0910261816x3c49d4ccr60a80a88dd4cfac9@mail.gmail.com>
Subject: Re: git vs hg commit counts?
To: Junio C Hamano <gitster@pobox.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       git <git@vger.kernel.org>, mercurial@selenic.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 2:18 AM, Junio C Hamano <gitster@pobox.com> wrote:
> We simplify a merge history by discarding one branch when the merge result
> matches one of the parents.  Does "hg" know how to do that as well?

57 of the differing changesets are normal merges (probably what Junio explained)
3 are duplicate changesets in hg, probably also related to that
27 changesets are octopus merge fixups

wrt octopus merges: in git, one merge commit can have an arbitrary
number of parents, but in hg a merge changeset always has 2 parents --
so a octopus merge is represented as multiple distinct changesets.

Marti
