Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbXK2Hvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbXK2Hvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXK2Hvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:51:39 -0500
Received: from mx12.go2.pl ([193.17.41.142]:50511 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754610AbXK2Hvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:51:38 -0500
Date: Thu, 29 Nov 2007 08:56:15 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: davids@webmaster.com
Cc: larry.finger@lwfinger.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
Message-ID: <20071129075615.GA9962@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEBHIIAC.davids@webmaster.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-11-2007 03:34, David Schwartz wrote:
>> Thanks for the help. Someday, I hope to understand this stuff.
>>
>> Larry
> 
> Any code either deals with an object or it doesn't. If it doesn't deal with
> that object, it should not be acquiring locks on that object. If it does
> deal with that object, it must know the internal details of that object,
> including when and whether locks are held, or it cannot deal with that
> object sanely.
...

Maybe it'll unnecessarily complicate the thing, but since you repeat
the need to know the object - sometimes the locking is done to
synchronize something in time only, so to assure only one action is
done at a time or a few actions are done in proper order, or/and
shouldn't be broken in the meantime by other actions (so, no need
to deal with any common data).

But, of course, we can say an action could be a kind of object too.

Regards,
Jarek P.
