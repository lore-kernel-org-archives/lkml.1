Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0BOCWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 21:22:11 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62605 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0BOCWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 21:22:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VK4xH8YufWB7flusQS7XfMVweuMhKsvK8tCbLZvDkz6FVvARBRfBJ1XRpduqoo25PU
         n9WDcI7Pyo4NJ2iGS0HBGsPyQMDQ4SdStzbDJRUXAQch9ZumvI1MrBiZ2oQ7v1Z3Zm4r
         Cte3uYakK4x5pwXgDaQkBELdMwra9bL5jIex8=
MIME-Version: 1.0
In-Reply-To: <aca0ce8b1002141350o16fcfe6bn658c0ca546b38da0@mail.gmail.com>
References: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
	 <520f0cf11002140510w5c57d196n12f8036ea6085c52@mail.gmail.com>
	 <aca0ce8b1002140657l4f767635ob9b1611e4da2540b@mail.gmail.com>
	 <520f0cf11002141254y3f4536a9ta968dbaefbff58f7@mail.gmail.com>
	 <aca0ce8b1002141350o16fcfe6bn658c0ca546b38da0@mail.gmail.com>
Date: Sun, 14 Feb 2010 21:22:06 -0500
X-Google-Sender-Auth: a646f1d629e1c8dc
Message-ID: <520f0cf11002141822i7c77c58cl2e00305ca6890f90@mail.gmail.com>
Subject: Re: [BUG]: Possibe recursive locking detected in sysfs
From: John Kacur <jkacur@redhat.com>
To: Eric Biederman <ebiederm@aristanetworks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 4:50 PM, Eric Biederman
<ebiederm@aristanetworks.com> wrote:
>> Sure, are you referring to the patch-set that begins with
>> "[PATCH 1/6] sysfs: Serialize updates to the vfs inode"?
>
> Sorry no.
>
> http://lkml.org/lkml/2010/2/11/329
>

I applied your patch, and yes, it removed the possible recursive
locking detected message, but everything still froze.
I don't think I really have any good info from the crash to report.
Your patch seems to have added the symptom of a huge number of
BUG: key ffff880126269e40 not in .data!
BUG: key ffff880136fc03f0 not in .data!

messages to my log.

If there is any other info that I can provide that would be useful,
please let me know.
