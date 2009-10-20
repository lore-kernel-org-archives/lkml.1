Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZJTNTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZJTNTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZJTNTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:19:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40919 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZJTNTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:19:13 -0400
Date: Tue, 20 Oct 2009 15:19:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 3/5] cfq-iosched: reimplement priorities using
	different service trees
Message-ID: <20091020131916.GI10727@kernel.dk>
References: <200910192221.23564.czoccolo@gmail.com> <20091020005813.GD10727@kernel.dk> <4e5e476b0910200343s1d7913daq5719d8a4d84fb491@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0910200343s1d7913daq5719d8a4d84fb491@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20 2009, Corrado Zoccolo wrote:
> On Tue, Oct 20, 2009 at 2:58 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Oct 19 2009, Corrado Zoccolo wrote:
> >> We use different service trees for different priority classes.
> >> This allows a simplification in the service tree insertion code, that no
> >> longer has to consider priority while walking the tree.
> >
> >> +enum wl_prio_t {
> >> +     IDLE_WL = -1,
> >> +     BE_WL = 0,
> >> +     RT_WL = 1
> >> +};
> >
> > WL?
> It stands for "workload". When defining all-caps constants, one has to
> avoid possible clashes adding pre/suf-fixes.
> Any suggestion for better naming?

Nobody will guess that. Make variable/enum names as short as possible,
but not so short that their meaning are incomprehensible. Suggestion
would be to use IDLE_WORKLOAD etc.

-- 
Jens Axboe

