Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYKSVAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYKSVAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYKSU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:59:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:14944 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYKSU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:59:54 -0500
Message-ID: <49247E43.1070108@codemonkey.ws>
Date: Wed, 19 Nov 2008 14:59:47 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] always assign userspace_addr
References: <1226977462-8086-1-git-send-email-glommer@redhat.com> <492436DE.2080906@codemonkey.ws> <20081119184357.GB25917@poweredge.glommer> <49246014.5000001@codemonkey.ws> <20081119205332.GA27378@poweredge.glommer>
In-Reply-To: <20081119205332.GA27378@poweredge.glommer>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> On Wed, Nov 19, 2008 at 12:51:00PM -0600, Anthony Liguori wrote:
>   
>> But the problem still exists even with this code.  I checked.
>>
>> So if you have something working without modifying the kernel, can you  
>> post it?
>>
>> Regards,
>>
>> Anthony Liguori
>>     
>
> Ok, how do you feel about this one?
>
> My proposal is to always delete a memslot before reusing the space,
> but controlling this behaviour by a flag, so we can maintain backwards
> compatibility with people using older versions of the interface.
>   

Is the old behavior ever correct?  I think it's always wrong.

Regards,

Anthony Liguori


