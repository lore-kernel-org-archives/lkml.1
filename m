Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZIYIe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZIYIe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZIYIeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:34:24 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50745 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbZIYIeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:34:23 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4ABC80B0.5010100@crca.org.au>
Date: Fri, 25 Sep 2009 18:34:56 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
References: <4AB9A0D6.1090004@crca.org.au> <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

KAMEZAWA Hiroyuki wrote:
>> I have some code in TuxOnIce that needs a bit too (explicitly mark the
>> VMA as needing to be atomically copied, for GEM objects), and am not
>> sure what the canonical way to proceed is. Should a new unsigned long be
>> added? The difficulty I see with that is that my flag was used in
>> shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
>> function would need an extra parameter too..
> 
> Hmm, how about adding vma->vm_flags2 ?

The difficulty there is that some functions pass these flags as arguments.

Regards,

Nigel
