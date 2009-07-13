Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZGMLcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZGMLcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZGMLcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:32:03 -0400
Received: from smtp.df.ru ([195.42.160.16]:41919 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbZGMLcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:32:03 -0400
Date: Mon, 13 Jul 2009 15:32:52 +0400
From: Alexey Vlasov <renton@renton.name>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Counters in df, du
Message-ID: <20090713113252.GB5569@beaver.vrungel.ru>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <87fxd19cfq.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 11:09:29AM +0200, Andi Kleen wrote:
> Alexey Vlasov <renton@renton.name> writes:
> >
> > I know that df, du can show different values if some files were deleted,
> > but the processes which opened these files are still acting.
> 
> You can check for that by doing ls -l /proc/*/fd | grep deleted
> 
> It won't tell you the file size though.

There comes a big list, like this:

lowx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
lrwx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
lrwx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
[cut]
lrwx------ 1 root root 64 Jul 13 15:29 317 -> /tmp/ZCUDXiOHCk (deleted)
lrwx------ 1 root root 64 Jul 13 15:29 317 -> /tmp/ZCUDXiOHCk (deleted)
lrwx------ 1 root root 64 Jul 13 15:29 317 -> /tmp/ZCUDXiOHCk (deleted)

But you can see the file date, these are new files and by next search
you won't see them any more.

The most interesting is that the /tmp size constantly grows.

-- 
BRGDS. Alexey Vlasov.
