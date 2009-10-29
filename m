Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZJ2T5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZJ2T5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZJ2T5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:57:30 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40913 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbZJ2T53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SZRKmjyWLaCKZiaZbxa+aS279s9bGJoM+zmIYh+pJWImMIUs39Z9OszDC0a5PANFkx
         KIj+6ECcIPkMSSQEgqpaG5KyDdxAHMmtOXSTgeEfhgwUA7sAMoNDUed1l8/CSK04X4s/
         y3+gpAI6G3J78Cz7DK2MaOSSX1MhBfxj7jcKc=
MIME-Version: 1.0
In-Reply-To: <6dRYo8ss7vL.A.haF.Are5KB@chimera>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.haF.Are5KB@chimera>
Date: Thu, 29 Oct 2009 15:57:32 -0400
X-Google-Sender-Auth: 9f4f0195feddef8d
Message-ID: <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com>
Subject: Re: [Bug #14472] EXT4 corruption
From: Andrew Lutomirski <luto@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Shawn Starr <shawn.starr@rogers.com>, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 2:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14472
> Subject         : EXT4 corruption
> Submitter       : Shawn Starr <shawn.starr@rogers.com>
> Date            : 2009-10-13 2:07 (14 days old)
> References      : http://marc.info/?l=linux-kernel&m=125539997508256&w=4
> Handled-By      : Theodore Tso <tytso@mit.edu>
>


This but is *not* fixed.  I just triggered it a few minutes ago by
abusing i915 and drm, which caused a panic.  This is slightly newer
than 2.6.32-rc5, with a couple of i915 bugfixes thrown in.

Photos are here:
http://web.mit.edu/luto/www/ext4_crashphotos/

This is a very nasty regression, for obvious reasons.

--Andy
