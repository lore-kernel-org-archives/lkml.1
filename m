Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYDJHRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYDJHRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYDJHRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:17:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33773 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYDJHRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:17:45 -0400
Date: Thu, 10 Apr 2008 09:22:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com, mingo@elte.hu,
       ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080410072218.GB10019@one.firstfloor.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org> <ac8af0be0804090204t79beaca2qe077a28fc4a515ad@mail.gmail.com> <20080409091307.GG19010@one.firstfloor.org> <ac8af0be0804092351g5388f75fr53cd4cf0774e0fd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8af0be0804092351g5388f75fr53cd4cf0774e0fd9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you please elaborate on Active / Total Caches? The meaning of
> other lines are obvious to me.

slab keeps some objects ready on a free list for quick access. Total
includes those. active are only the objects which are truly allocated.

-Andi
