Return-Path: <linux-kernel-owner+w=401wt.eu-S1031070AbXD2TJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031070AbXD2TJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031071AbXD2TJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:09:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:3249 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031070AbXD2TJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ua2yREWxVhsstfEosZjnAJY2AfQUq4n2sNL2uPxzbuft8gdmMsqIM4pnEDT/0UuS3c61gBsHDa3mBRJ70gp/U7hABkAav5MXOMDCeSgIEdAOk8Dq510SwiGKBncqXMTJEhC6nBIldPqDxWYuJ3iLQcByvPGVjY+g/23VM5LoUw0=
Message-ID: <c24352ca0704291209u41ea9b00x16c2dbb0fa866446@mail.gmail.com>
Date: Sun, 29 Apr 2007 12:09:08 -0700
From: "Jeff Schroeder" <jeffschroed@gmail.com>
Reply-To: jeffschroeder@computer.org
To: linux-kernel@vger.kernel.org
Subject: Re: Re: [AppArmor 00/41] AppArmor security module overview
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Wagner <daw <at> cs.berkeley.edu>
Subject:
> David Wagner wrote:

...snip...

>> I still think that ptrace() is not the best way to implement this kind
>> of security tool, and I think it's entirely understandable that they did
>> not use ptrace.  I do not think it is a fair criticism of AppArmor to say
>> "AppArmor should have used ptrace()".

Take a look at utrace in -mm, it offers a completely backwards compatible
ptrace() syscall implemented as a module ontop of it. utrace looks like the
way things will be going forward
http://people.redhat.com/roland/utrace/2.6-current/0-intro.txt

Think of ptrace() implemented using utrace as ptrace that "Sucks Less TM".
Maybe Andy will let utrace out of -mm for 2.6.23.

(please cc: me in any responses)

-- 

Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
