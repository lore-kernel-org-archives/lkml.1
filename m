Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZFYXkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZFYXkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZFYXkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:40:12 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:39650 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZFYXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mjtNlpDcs+hJzRl3eqE5osK6U1gwN29hKcn5aVAC3hcd9QkKYpVFZt/WhK8IsrZw0y
         YKhX//waK94a1HaO5aZTjnrCAEHSOFDNJtoeJCWsewePOGz1IRs/OLibLm9p0PQbjHcn
         jwoEjKl0Y4y/hB+uywgRdF21Ov7QzK0m50u28=
Message-ID: <4A440B08.6050006@gmail.com>
Date: Thu, 25 Jun 2009 17:40:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: kernel mailz <kernelmailz@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slowing down the schedular, How?
References: <abe8a1fd0906251136t36d78428k90a610fdff987ab6@mail.gmail.com>
In-Reply-To: <abe8a1fd0906251136t36d78428k90a610fdff987ab6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 12:36 PM, kernel mailz wrote:
> Hi,
>
> I have a SMP linux running on 85xx poweprc. Say on Core 0 and Core 1
> two different processes are running and on both the schedular runs.
> Now for some special case, if one of my process issues a ioctl which
> gets serviced by a kernel module, I wish to slow the schedular on that
> core only. Otherwise the performance will get degraded.
>
> Should I use highest priority tasklet, will it be sufficient or i need
> to do something special
>
> -TZ

Not clear what you mean by "slowing the scheduler" or "performance will 
get degraded". The scheduler is not a process, it runs when something 
triggers it to run.
