Return-Path: <linux-kernel-owner+w=401wt.eu-S933419AbYCGJc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbYCGJc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764992AbYCGJaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:30:46 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:22516 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762092AbYCGJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:30:43 -0500
To: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
References: <47D06F77.29711.A05566EC@Frantisek.Rysanek.post.cz>
	<75b66ecd0803061905n5c06663cv2b75659917461199@mail.gmail.com>
	<47D0EA6B.18428.A235AEC4@Frantisek.Rysanek.post.cz>
From: Andi Kleen <andi@firstfloor.org>
Date: 07 Mar 2008 10:30:40 +0100
In-Reply-To: <47D0EA6B.18428.A235AEC4@Frantisek.Rysanek.post.cz>
Message-ID: <87hcfig9tr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Mar 2008 09:24:10.0371 (UTC) FILETIME=[001EF530:01C88035]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Frantisek Rysanek" <Frantisek.Rysanek@post.cz> writes:

> On 7 Mar 2008 at 4:05, Lee Revell wrote:
> > >  I didn't even try Ext3, I know it's not appropriate for this sort of
> > >  capacity.
> > 
> > Where did you get that idea?
> >
> Hmm... Google can find sources on the 'net claiming that Ext3 has a 
> maximum of 2 or 4 TB. Nice to know that I'm wrong, 

You're not wrong (for 4K ext2s). Only ext4 lifted that limit, but it is
still experimental.

BTW your problems mostly sound like driver issues. Some drivers 
(and some controller firmwares) have problems with large block numbers

-Andi
