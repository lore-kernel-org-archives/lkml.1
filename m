Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbZGPHRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbZGPHRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZGPHRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:17:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58633 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZGPHRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:17:09 -0400
Message-ID: <4A5ED38F.5070708@garzik.org>
Date: Thu, 16 Jul 2009 03:15:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] GIT 1.6.4.rc1
References: <7vmy75bg2f.fsf@alter.siamese.dyndns.org> <4A5EA598.5050801@garzik.org> <7v3a8xb0lz.fsf@alter.siamese.dyndns.org> <4A5ECC09.3010405@garzik.org> <7vocrl9kwi.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7vocrl9kwi.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> I want to publish this tree to the world via a *.kernel.org-like
>> system, so my task is to
>>
>> 	scp -r /spare/repo/cld/.git remote.example.com:/pub/scm/cld.git
>>
>> but if I do this with scp, then future pushes to
>> remote.example.com:/pub/scm/cld.git emit the warning about updating
>> the currently checked-out branch
> 
> I think "scp -r" is a wrong way to "clone", as it will copy .git/config
> that is specific to your local work tree that does not apply to the
> situation at remote.example.com anyway.  You do not want to push into your
> local repository with a work tree you are "scp -r"ing out of, but you do
> want to push into the one at remote.example.com.
> 
> Interestingly enough, we had a two separate thread about making a bare
> repository out of a repository with a work tree today ;-)
> 
> 	remote.example.com$ cd /pub/scm/
>         remote.example.com$ git clone --bare over.there:/spare/repo/cld/.git cld.git

That direction doesn't work due to firewalls, hence the scp out /to/ 
remote.example.com.

So, will this make git happy?  :)

[starting on local machine, where I do development]
1) scp -r /spare/repo/cld remote.example.com:/tmp

2) ssh remote.example.com

3) cd /pub/scm

4) git clone --bare /tmp/cld/.git cld.git

Regards,

	Jeff



