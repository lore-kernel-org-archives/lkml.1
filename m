Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbZFPNOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbZFPNOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 09:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZFPNON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 09:14:13 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:40781 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZFPNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 09:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HKcY5g6fTxBh8mRhCr1fvTCS9mvaUvKz8gGPzSQI9roalHXwETyFPG4NpXPLqUhaF0
         tthOO9DXqk4o8JKVq57jRS6oFz4/hm+bwm3GBhHuV0gs5HC+oBGHQDE9rmlnP48pysGw
         zNwppQp0F9M6FNlWe5aWyMxSepgvfeR/n4ON8=
Message-ID: <4A379AA6.9030508@gmail.com>
Date: Tue, 16 Jun 2009 15:14:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.4 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr <sam@ravnborg.org>
Subject: Re: kbuild docs regression
References: <4A367744.2050207@oracle.com>
In-Reply-To: <4A367744.2050207@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2009 06:31 PM, Randy Dunlap wrote:
> make htmldocs
> without using "O=dir" now (as of 2.6.30-git8) fails with
> 
>   DOCPROC Documentation/DocBook/deviceiobook.xml
>   DOCPROC Documentation/DocBook/device-drivers.xml
> exec /scripts/kernel-doc: No such file or directory
> exec /scripts/kernel-doc: No such file or directory
> make[1]: *** [Documentation/DocBook/deviceiobook.xml] Error 1
> 
> (+ more)
> 
> Using V=1 shows that SRCTREE is set but KBUILD_SRC is not set:

Hmm, thanks, actually it's set, but it's empty :(. Is it expected, or is
it a build-sys bug?
