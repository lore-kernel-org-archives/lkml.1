Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZIBLkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZIBLkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZIBLkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:40:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZIBLkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:40:45 -0400
Message-ID: <4A9E59BC.2090902@redhat.com>
Date: Wed, 02 Sep 2009 14:40:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] add sysctl for kvm wallclock sync
References: <1251805848-17451-1-git-send-email-glommer@redhat.com> <1251805848-17451-2-git-send-email-glommer@redhat.com> <1251805848-17451-3-git-send-email-glommer@redhat.com> <4A9E16AD.8080508@redhat.com> <20090902113124.GK30340@mothafucka.localdomain>
In-Reply-To: <20090902113124.GK30340@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2009 02:31 PM, Glauber Costa wrote:
>> I think the overall idea is very interesting, but I also think that it should be
>> disabled by default.  Because of the problems with time in virtualization,
>> people are already conditioned to run ntpd inside their guests, and this
>> kvmclock change will "fight" with ntpd.  Also, the command "# date 09091323" (or
>> whatever) ceases to work like it does on bare-metal, so I think it has to be an
>> opt-in feature.
>>      
> I don't disagree.
>
> Actually, I thought about that myself a few hours after I sent the patch.
> Avi, do you have a word on that ?
>    

Chris' arguments are compelling IMO.

-- 
error compiling committee.c: too many arguments to function

