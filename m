Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZBKOh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZBKOh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZBKOhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:37:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:34699 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZBKOhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S+uYJjeSGxBwosWKw2NVul1ZcshNqKeXfdeH6DWXILSlf9ppRTZY3XFAq6ppTAqbWa
         FLpQNApDfcT9DY1zkThBdMX+lXjg2AF+LjYDZHIzEIzH/Yp7H+4yeYwxtSNQJ/0GLd/J
         otQDNjs8IOsX1y+4kPj6orFHWgOOxN0qaPMrA=
MIME-Version: 1.0
In-Reply-To: <20090211133648.GA10273@fogou.chygwyn.com>
References: <2d42915c0902110255k3c0741a9s6830765bce6be052@mail.gmail.com>
	 <20090211133648.GA10273@fogou.chygwyn.com>
Date: Wed, 11 Feb 2009 17:37:11 +0300
Message-ID: <2d42915c0902110637o2c0a88c7h72b280b972a6162e@mail.gmail.com>
Subject: Re: GFS2 file locking issues
From: Kirill Kuvaldin <kirill.kuvaldin@gmail.com>
To: steve@chygwyn.com
Cc: linux-cluster@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 4:36 PM,  <steve@chygwyn.com> wrote:
> Hi,
>
> On Wed, Feb 11, 2009 at 01:55:08PM +0300, Kirill Kuvaldin wrote:
>> Hi,
>>
>> I'm trying to understand how the FS locking mechanism should work.
>>
>> I'm running a clustered GFS2 across two nodes, each node is a Xen domU.
>> To check if locking works correctly I wrote the simple perl script below.
>> Basically the script opens a file, locks it to prevent others from
>> writing into it, writes 20 lines into it, then unlocks and closes.
>>i
>
> It should be exactly the same on GFS and GFS2, after all the code for
> flock is almost identical between the two. What mount options did you
> use?

No specific options used, just mount -t gfs2 /dev/gfsc/lvol0 /gfs2...

> Which lock manager are you using - I presume lock_dlm?
>

Yes, the FS was created using to be used with lock_dlm. I'm not sure
if it is actually used for GFS2. How can I check that?

Kirill
