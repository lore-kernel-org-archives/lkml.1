Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZGXSEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZGXSEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZGXSEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:04:42 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:63211 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbZGXSEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=evBt7Gw13m29yI/E4Waw2mVH9ZAbYniJD9oLw64P2QggpyAbClntJiulNAXtmXyQKj
         m8h3hKFUMliB80mL7w11Fq1Ntjz2Z+jZMWbZDVqWyXzkb2YLSlCgQlBInGGmZ9jgBhup
         YQO/xAx8CBqzXqXerfktMeRz3P/Rdnz8l0QMc=
MIME-Version: 1.0
In-Reply-To: <200907241349.58754.vapier@gentoo.org>
References: <f5a7b3810907240831t75a058a2m96abdc28a28c4365@mail.gmail.com>
	 <200907241349.58754.vapier@gentoo.org>
Date: Fri, 24 Jul 2009 23:34:40 +0530
Message-ID: <f5a7b3810907241104g498b00a6i60c8858b8805091a@mail.gmail.com>
Subject: Re: [LTP] Char Limit issue on 2.6.29 kernels
From: naresh kamboju <naresh.kernel@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       maxin john <maxinbjohn@gmail.com>, brinda_mn@yahoo.co.in,
       Oleg Nesterov <oleg@redhat.com>, tim.bird@am.sony.com,
       rohit.170309@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, Jul 24, 2009 at 11:19 PM, Mike Frysinger<vapier@gentoo.org> wrote:
> On Friday 24 July 2009 11:31:59 naresh kamboju wrote:
>> I have come across with char Limit issue on 2.6.29 kernels.
>>
>>
>> SIGFAULT:
>>
>> #define SIZE            8053759
>> char buf1[SIZE] ;
>>
>> NO SIGFAULT:
>>
>> #define SIZE            8053758
>> char buf1[SIZE] ;
>>
>> This SIGFAULT not observed on 2.6.23 kernels.
>
> -ENOINFO
>
> post some actual code rather than saying "i declared a large buffer and things
> crashed".

currently i am debugging this issue.
i'll come up with more details.

>is there a reason you cc-ed LTP ?  is this a crash i >a LTP test ?
No.
it is not a test cases of LTP.
i am a member of LTP. want to share this information to LTP community.

-naresh

>
>> What could be the changes that effecting from 2.6.23 to 2.6.29 kernels.
>> Please share me the information.
>
> git log v2.6.23..v2.6.29
> -mike
>
