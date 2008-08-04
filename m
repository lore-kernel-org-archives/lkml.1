Return-Path: <linux-kernel-owner+w=401wt.eu-S1762675AbYHDUmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675AbYHDUmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYHDUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:42:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:51592 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbYHDUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DIJr3597lf4PPnAdy/JelDh0o0GFA3xfvU2R7R2AxnThrtQV3LMI3nlaUCEVKXuHMY
         tSxKaja35J+ReIUnskMHoFrzJP0iqo1bhLqwKpU4Ni/n46DnErbdx4l8b4614GspjxQl
         cQIukP+nLscCCaBJM6uMK1gYw7dDi9fJ7uk6o=
Message-ID: <489769B4.7030700@gmail.com>
Date: Mon, 04 Aug 2008 22:42:28 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org
Subject: Re: Too many I/O controller patches
References: <20080804.175126.193692178.ryov@valinux.co.jp> <1217870433.20260.101.camel@nimitz> <48974BD3.6050503@linux.vnet.ibm.com>
In-Reply-To: <48974BD3.6050503@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Dave Hansen wrote:
>> On Mon, 2008-08-04 at 17:51 +0900, Ryo Tsuruta wrote:
>>> This series of patches of dm-ioband now includes "The bio tracking mechanism,"
>>> which has been posted individually to this mailing list.
>>> This makes it easy for anybody to control the I/O bandwidth even when
>>> the I/O is one of delayed-write requests.
>> During the Containers mini-summit at OLS, it was mentioned that there
>> are at least *FOUR* of these I/O controllers floating around.  Have you
>> talked to the other authors?  (I've cc'd at least one of them).
>>
>> We obviously can't come to any kind of real consensus with people just
>> tossing the same patches back and forth.
> 
> Ryo and Andrea - Naveen and Satoshi met up at OLS and discussed their approach.
> It would be really nice to see an RFC, I know Andrea did work on this and
> compared the approaches.
> 

yes, I wrote down something about the comparison of priority-based vs
bandwidth shaping solutions in terms of performance predictability.  And
other considerations, like the one I cited before, about dirty-ratio
throttling in memory, AIO handling, etc.

Something is also reported in the io-throttle documentation:

http://marc.info/?l=linux-kernel&m=121780176907686&w=2

But ok, I agree with Balbir, I can try to put the things together (in a
better form in particular) and try to post an RFC together with Ryo.

Ryo, do you have other documentation besides the info reported in the
dm-ioband website?

Thanks,
-Andrea
