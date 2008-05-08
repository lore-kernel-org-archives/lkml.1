Return-Path: <linux-kernel-owner+w=401wt.eu-S934359AbYEHW6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359AbYEHW6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYEHW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:58:25 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:3283 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765451AbYEHW6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:58:23 -0400
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: Rafael J Wysocki <rjw@sisk.pl>, Justin Mattock <justinmattock@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: Regression: starting X locks box with git master
In-Reply-To: <200805072353.02085.rjw@sisk.pl> (Rafael J. Wysocki's message of
        "Wed, 7 May 2008 23:53:01 +0200")
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
        <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
        <m37iemq3qa.fsf@lugabout.jhcloos.org> <200805072353.02085.rjw@sisk.pl>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Thu, 08 May 2008 18:57:39 -0400
Message-ID: <m3tzh8bdz9.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:080508:linux-kernel@vger.kernel.org::BQ14EOiNz7z80ISx:000000000000000000000000000000000JtE1
X-Hashcash: 1:23:080508:rjw@sisk.pl::nU876B/xfV0RWDHF:0000004RCB
X-Hashcash: 1:23:080508:justinmattock@gmail.com::KINIm098XEQPq5gi:0000000000000000000000000000000000000091/d
X-Hashcash: 1:23:080508:yhlu.kernel@gmail.com::ePJQpp8f8AF2bN1J:0000000000000000000000000000000000000000FIKM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git master as of 3de2403e allows me to run X again.

After installing the new kernel I also re-compiled all of the X server
stack (libdrm, libpciaccess, mesa, the X server and the video driver).  
I don't know how much of a difference that made.

I don't know whether the problem was sched, x86, agp or dri related,
but AFAICT it is now fixed.

Thanks,

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
