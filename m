Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXJ3Smr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXJ3Smr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXJ3Smj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:42:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47879 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbXJ3Smi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:42:38 -0400
Date: Tue, 30 Oct 2007 19:42:37 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Peter Dolding <oiaohm@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl> 
 <4726377A.4080807@crispincowan.com> <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(please do not drop Cc, or I would have lost this thread part if I had 
not been on lkml. And sometimes I am not because of the volume. Thanks.)

On Oct 30 2007 15:13, Peter Dolding wrote:
>On 10/30/07, Crispin Cowan <crispin@crispincowan.com> wrote:
>
>>     * I have no clue what family to put MultiADM or Dazuko into
>
>MultiADMIN falls under o my god head ache.  This is more a posix
>standard feature altered ie 1 root user turned into many.  This really
>risks breaking the other models as a LSM.

I disagree.

Traditionally, Linux has given a process all capabilities when the
UID changed to 0 (either by setuid(2) or executing a SUID binary).
This has been relieved over the years, and right now with LSMs in the
field, it is possible to 'deactivate' this special case for UID 0.

SELinux does not have this special case for UID 0. Neither does it
seem to use capabilities (quick grep through the source). So
basically, all users are the same, and no one has capabilities by
default. Does SELinux thus break with other LSMs?

Now assume a SELinux system where all users have all capabilities
(and the policy that is in place restricts the use of these
capabilities then) -- should not be that unlikely. Does that break
with other LSMs?
