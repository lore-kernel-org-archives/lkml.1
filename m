Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYKTI5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYKTI5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYKTI5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:57:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:64091 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYKTI5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vGjzo4grt0C5fjoUsPyy6NhrTIH9e/XEJxnBpoVrTZ7OEpGrGyF0ILHD1AoPHIztiH
         goQGeLGYJSUdoeedFSoShd2tlkD5UhZW5xtegvs27fSA5DozV9UrR0YuX7tzsmmxPkPh
         dKH4O0YLCRl39PQGtu5f+iVf+M3vIck6kbwak=
Message-ID: <19f34abd0811200057n73cfae6va5efc1d91bc438e4@mail.gmail.com>
Date: Thu, 20 Nov 2008 09:57:14 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: gitwatch: RSS feed of checkpatch+coccinelle against new commits in mainline
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Julia Lawall" <julia@diku.dk>
In-Reply-To: <20081120082639.GC14274@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0811181420i2b582fd2jcaa685b0cbb5c979@mail.gmail.com>
	 <20081120082639.GC14274@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 9:26 AM, Andy Whitcroft <apw@shadowen.org> wrote:
> On Tue, Nov 18, 2008 at 11:20:48PM +0100, Vegard Nossum wrote:
>> I've written a script that follows the mainline git repository and
>> runs checkpatch against all new commits. The result is available as an
>> RSS stream:
>>
>>     http://kernel.org/~vegard/gitwatch.rss
>>
>> Only commits with warnings or errors are shown. Files that change are
>> also searched for known/frequent coding errors using Coccinelle and a
>> selection of the semantic patches found on the Coccinelle website.
>
> Thats pretty intresting.  Looking at some of the cochinelle output I am
> a little confused as to what its saying.  Am I right in thinking that
> for those reports that a proposed patch is printed, after the comment
> for the original patch?  If so it might be helpful to say something like
> 'proposed modificiation' just before the patchlet.

You are correct, those are the modifications that would have been made
by the semantic patch. I agree, it might look like the log text
belongs to the patch below, which is wrong. We are also planning to
add a description to each of the semantic patches so that a better
explanation is given for the change.

> Also which version of checkpatch is this output being generated with?
> The one at the head of the git tree or something else?  I see a couple
> of false positives in there that I know I have fixed already.

Yes, it's a copy of the one in linux-2.6.git (after v2.6.28-rc4). The
file itself says 0.24. Which false positives were you thinking about?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
