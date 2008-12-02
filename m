Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYLBTa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYLBTa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYLBTaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:30:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47401 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYLBTaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:30:01 -0500
Message-ID: <49358CC2.6080902@redhat.com>
Date: Tue, 02 Dec 2008 21:30:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com> <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com> <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com> <20081202190914.GA12115@hades>
In-Reply-To: <20081202190914.GA12115@hades>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques wrote:
> Ok, I am not sure but there is a possibility of having the vboxdrv driver
> loaded. _But_ I was not using, i.e., I do not use VirtualBox.  In my
> attempts to reproduce the issue, I tried to load this module but, unfortunatly,
> my distro has this package broken ATM (err... in fact, the problem is not the
> distro but me - I am using an unstable version).
>
> vboxdrv could be a problem if I was using it, but I believe it shouldn't cause
> this if it is not being used... but it's just a guess.
>   

Let's keep an eye open on it.  If it reproduces, be sure to note what 
drivers are loaded.  Meanwhile, I don't recommend having different 
virtualization modules loaded concurrently.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

