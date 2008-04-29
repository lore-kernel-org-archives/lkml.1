Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbYD2Hu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbYD2Hu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYD2HuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:50:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:47487 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYD2HuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RRfHhCDTt/k5XMtPsZBJCdCVn/vvIjlHeWdo/B6kSCMC/KbzR+M401cayA2mW4GJxZFT9fW4mphCTzpEZfuEfI62HWgbWCGcg4uFWgppG2F/fpk6+M1VQqd3XSN4HEj0qYEHLtmJ39jGg79j8NY1ZHYpQg4etlB2DO6mLBF68+U=
Message-ID: <aa79d98a0804290050i26300631kbb589eaa0c528088@mail.gmail.com>
Date: Tue, 29 Apr 2008 11:50:15 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Markus Metzger" <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4816BEC8.1080708@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428191504.GA6842@cvg> <4816BEC8.1080708@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:23 AM, David Newall <davidn@davidnewall.com> wrote:
> Cyrill Gorcunov wrote:
>  > -                     return 0;
>  > +                     return NULL;
>
>  Why?  The constant 0 is C's official symbol for a null pointer.
>

Yes, but by using NULL explicilty allows you to separate _pointers_ from
numbers on review process. Or maybe you wanna drop NULL at all? I dont
think you will like that ;)
