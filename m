Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbZHWQDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbZHWQDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 12:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbZHWQDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 12:03:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:23367 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933839AbZHWQDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 12:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f1qmyparX485e94t8gAQJ8/I9NCp3oPJ48CdGd4516DVBqA7iwknqrpJ5s9luRJhVX
         xwQQEYdkN35qfHCfL0sdL/AN9T/AAWzG4Y/qHZiOoZkeyboqhOvSqIKslZqgN9oWui+0
         jc4heK27dV8qBaSSJWmOJ3xctzspBLit0zSQU=
Date: Mon, 24 Aug 2009 00:06:56 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Matthias Urlichs <matthias@urlichs.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nicolas Palix <npalix@diku.dk>, linux-kernel@vger.kernel.org,
       Yoann Padioleau <yoann.padioleau@gmail.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] scripts: add typdef removal tool
Message-ID: <20090823160656.GB12070@hack>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com> <20090817060203.GL5039@cr0.nay.redhat.com> <4A8E5F73.6010904@gmail.com> <1251032950.10339.1101.camel@kiste>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251032950.10339.1101.camel@kiste>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 03:09:10PM +0200, Matthias Urlichs wrote:
>On Fri, 2009-08-21 at 10:48 +0200, Jiri Slaby wrote:
>> >> +if [[ $# -lt 3 ]]; then
>> 
>> Could that be [ ] instead of [[ ]]?
>> 
>Yes. In fact, it should be, as [[ ]] is a bashism.

Also that the classic test command is enough here,
no need to bother conditional expression.


-- 
Live like a child, think like the god.
 
