Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZIIOZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZIIOZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZIIOZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZIIOZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:25:24 -0400
Message-ID: <4AA7BACD.2090601@redhat.com>
Date: Wed, 09 Sep 2009 17:25:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Beth Kon <eak@us.ibm.com>, rostedt@goodmis.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM
 not in kernel
References: <3850.1252332427@turing-police.cc.vt.edu>            <4AA65CFE.50402@us.ibm.com> <22130.1252438888@turing-police.cc.vt.edu>
In-Reply-To: <22130.1252438888@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 10:41 PM, Valdis.Kletnieks@vt.edu wrote:
>
> Yeah, I was quite confused by the bisect results as well, I may end up
> re-doing it just to make sure I didn't screw something up along the way (since
> I started it with -rc7/HEAD as the good/bad, but most of the resulting
> kernels reported a pre-rc7 release (a 2.6.28 at one point, IIRC, and it
> finished at 31-rc2.
>    


This is normal, if a branch based on 2.6.28 was merged into 2.6.31-rc a 
bisect may detour through that branch and generate that version.

-- 
error compiling committee.c: too many arguments to function

