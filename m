Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYFSFmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYFSFmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYFSFmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:42:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:21298 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYFSFmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=di5LtO0Xp01u+GGreky7CzAJUOwKt+J1PwoSzvzbCh6GaGkYYioa0gVd8VajgycGyJ
         7U3HxAYK/WFK28/k2eszJz9aj3rNqrRT2HGSL4ElAJcfEUKLlLzdr4btctM0Wo6EH+Jp
         tSB9EDHfQZHq6vKMQiL49hDtZ7aeUQMRW2w7s=
Message-ID: <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
Date: Thu, 19 Jun 2008 15:42:34 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ext4@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4859F075.2050207@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4859F075.2050207@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 3:36 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> In the kerneloops.org stats, a new oops is rapidly climbing the charts.
> The oops is a page fault in the ext3 "do_slit" function, and the first
> report of it was with 2.6.26-rc6-git3.
>
> It happens with various applications; the backtraces are at:
>
> http://www.kerneloops.org/search.php?search=do_split
>

This is a bug in rawhide in gcc miscompiling something...

https://bugzilla.redhat.com/show_bug.cgi?id=451068

Dave.
