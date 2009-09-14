Return-Path: <linux-kernel-owner+w=401wt.eu-S933870AbZINVHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbZINVHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933711AbZINVHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:07:46 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:39516 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933685AbZINVHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EA1ZSrXeR50wlxnYAmSk22MsYS2sxMMq7dO88AZOaRlfND8uLAQ6+6XPW39zAIlEen
         qxX81bkGWNchId8sQ7IF4KAiwm+lcLFfnszs+FQxGBSKN+ysN5TvzMHPyTLyAronfn5n
         O/J70tuYXjAQNyt2cKHLy8JEHwCoaEgELnIZE=
MIME-Version: 1.0
In-Reply-To: <1252962263.11643.232.camel@desktop>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org> 
	<1252961412.11643.215.camel@desktop> <8bd0f97a0909141357y60d7807bm99146d757e6f61da@mail.gmail.com> 
	<1252962263.11643.232.camel@desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Sep 2009 17:07:21 -0400
Message-ID: <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com>
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 17:04, Daniel Walker wrote:
> On Mon, 2009-09-14 at 16:57 -0400, Mike Frysinger wrote:
>> On Mon, Sep 14, 2009 at 16:50, Daniel Walker wrote:
>> > On Mon, 2009-09-14 at 16:07 -0400, Mike Frysinger wrote:
>> >> Minor highlights:
>> >>  - shadow console to help with really early kernel output
>> >>  - proper decoding of double fault handling
>> >>
>> >> Otherwise, we've got the normal bug fixes, IPIPE updates, and clean ups.
>> >>
>> >
>> > Patches 15, 16, 20, 21, and 61 all have checkpatch errors some with
>> > several errors..  Could you clean those up those errors before sending
>> > this up stream?
>>
>> i already checked/reviewed the output in the series
>
> The remaining problems can be fixed .. Why did you leave those errors ?

i'm not going to sweat 80 col warnings when the line is 81 cols with
tabs of 8 spaces

as for the other errors, you probably didnt read the code.  you saw
"error" and assumed checkpatch was correct.  it isnt always as it isnt
a C parser.
-mike
