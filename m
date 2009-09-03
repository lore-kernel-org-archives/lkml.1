Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZICIWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZICIWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZICIWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:22:45 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:34212 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZICIWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NF0M5kEcM0hSPx8L/akqGLjq71sJkAKUPvJ3gQiUMrIKdhH+pZRXssNTlgXgmeqHf0
         eNnIAYcM6RB8g8cyW9NDUMa3JmWF4r5QE7ZCheo9VC1U6y9W1kESsg4ges9XdJvpbeob
         Q2or4zFFaNUt9WY3LCjuFrPzo/cQK/2LWhWPY=
MIME-Version: 1.0
In-Reply-To: <200909021636.35796.elendil@planet.nl>
References: <f1c9d250909020545x90c3610nb75c0716cdf4d440@mail.gmail.com>
	 <200909021636.35796.elendil@planet.nl>
Date: Thu, 3 Sep 2009 13:52:46 +0530
Message-ID: <f1c9d250909030122pa9dd02dw130409f823aa1b8c@mail.gmail.com>
Subject: Re: [BUG-rc8]: Kernel bootprocess
From: Tej <bewith.tej@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 8:06 PM, Frans Pop<elendil@planet.nl> wrote:
> Tej wrote:
>> Recently upgraded to 2.6.3-rc8. While doing I could not able to boot,
>> and boot process stop at dmesg saying something:
>> ADDR_CONF (NETDEV CHANGE): eth0 interface become ready.
>>
>> message seems success only but affter pressing alt+ctl+del. machine
>> boot without xserver and complete / with readonly filesystem. So I
>> couldn't capture whole dmesg.
>>
>> Now: I have bisected the problem (twice), and bisect result goes to
>> 0db501bd0610ee0c0aca84d927f90bcccd09e2bd is first bad commit
>> Author: Eric W. Biederman <ebiederm@xmission.com>
>>     inotify: Ensure we alwasy write the terminating NULL.
>
> Can you try with the current git mainline, or current snapshot kernel?
> There have been a couple of inotify fixes committed since rc8.

It Worked Properly.
Last Commit Pulled: 37d0892c5a94e208cf863e3b7bac014edee4346d

thanks,

>
> Cheers,
> FJP
>
