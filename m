Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZGUKFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZGUKFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZGUKFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:05:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47078 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZGUKFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:05:30 -0400
Message-ID: <4A65934B.9050904@redhat.com>
Date: Tue, 21 Jul 2009 18:07:07 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       mszeredi@suse.cz
Subject: Re: [Patch] pipe: use file_update_time() when hold i_mutex
References: <20090706053745.6338.50777.sendpatchset@localhost.localdomain> <20090720141150.e9d081ca.akpm@linux-foundation.org>
In-Reply-To: <20090720141150.e9d081ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 6 Jul 2009 01:35:30 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> file_update_time() should be called with i_mutex held,
>> move it before mutex_unlock().
>>
>>     
>
> Why do you believe that file_update_time() needs i_mutex?
>   
file_update_time() modifies inode, no? :)

