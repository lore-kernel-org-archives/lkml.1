Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYGGUA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYGGUA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYGGUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:00:48 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:36541 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbYGGUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qBxq83s8svZWpk9yxjAQviqmTPHOQHaYNiB7ugmAvskpCBpYSM/vzezL3U2ZJIMHmZ
         SVfgRVRj8JdWWaDksxxGUQOK1oRCM3cYnBtvyZ5DQPSboX7Iu2bfEDDkbFN3SpGO+M7e
         t1fKhhccS0Ipe0YZX1T3ZetsIwtwyJ6Fv+iYw=
Message-ID: <19f34abd0807071300w73371348gf358c1dc3f6446fb@mail.gmail.com>
Date: Mon, 7 Jul 2008 22:00:45 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vsprintf: fix gcc warning
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807071247480.11076@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080707192429.GA17551@damson.getinternet.no>
	 <alpine.LFD.1.10.0807071247480.11076@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 9:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, 7 Jul 2008, Vegard Nossum wrote:
>>
>> Does this look correct? Please disregard this if it has already
>> been fixed. Thanks.
>
> Looks fine. But the series I eventually committed avoided this issue, so
> please double-check current -git.

Oh, you're right. I was compiling/looking at tip/master which had your
old version. Sorry for the noise!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
