Return-Path: <linux-kernel-owner+w=401wt.eu-S1751863AbZG3Jfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbZG3Jfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZG3Jfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:35:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46419 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZG3Jfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:35:50 -0400
Message-ID: <4A716A80.5020907@redhat.com>
Date: Thu, 30 Jul 2009 12:40:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc4 oops in fsnotify extending logical volume
References: <4A7068C9.40802@redhat.com> <200907292313.47762.rjw@sisk.pl>
In-Reply-To: <200907292313.47762.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2009 12:13 AM, Rafael J. Wysocki wrote:
> On Wednesday 29 July 2009, Avi Kivity wrote:
>    
>> # lvextend -L +50G /dev/vg0/images
>>      
>
> I guess this is a regression?
>
>    

It's never happened to me before, and I extend volumes regularly, so I'd 
say it's a regression.  On the other hand after a reboot the command 
worked with the same kernel.

-- 
error compiling committee.c: too many arguments to function

