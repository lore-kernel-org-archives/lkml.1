Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbYEaQlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbYEaQlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYEaQlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:41:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:29070 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYEaQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=t2NWSqDnEetf2Eh3vWH0sm4DhIL0wJbslsAYZXnvNrvDOvMESIJECpuSOfxba4G4nXzfDK871M4E9iI88u2Ee5Iakkoq/OQmBdqkQDJyKueTG0d93bbm88ff0BZW/XPX9ccA67Qq07/LHhZswwhXkDA0ThX7/jDsbZON+hWva/Q=
Message-ID: <48417FAE.7040103@gmail.com>
Date: Sat, 31 May 2008 18:41:18 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Chris Frey <cdfrey@foursquare.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOM policy, overcommit control, and soft limits
References: <20080531102752.GA25244@foursquare.net>
In-Reply-To: <20080531102752.GA25244@foursquare.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Frey wrote:
> I'm sure someone has thought of this before me.  Does anything remotely
> similar to this already exist?  I've googled for OOM policy, but so far
> all I've seen is Rusty Lynch's patch from 2003, and really, I want this
> behaviour to happen when there is still a bit of memory left, so things
> can be dealt with before they are OOM-level dire.

Have you seen the OOM killer policy implemented in memory the resource
controller?
http://kernelnewbies.org/Linux_2_6_25#head-450b26e12955b8035a05cf07b3f31c501ee4bfab

BTW read the TODO comment in this commit log... ;-)
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c7ba5c9e8176704bfac0729875fa62798037584d

Maybe a possible solution could be to just run critical and non-critical
applications in 2 different cgroups, using different memory policies.
Anyway, userspace OOM handling would surely permit to implement more
interesting features.

-Andrea
