Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbYGQUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbYGQUMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbYGQUMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:12:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:35444 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYGQUMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=RH73jRxx2qKboZtMO6Sv74OHhh2hwaNogPlJDdymEnsaSCvcgYy+dPo6bkanQ/S+sp
         7hbCpa2RoU6cz3cpfM0Jj4xuS3ptBRgBLUBXy7SQ1xS3Wgf9XLZHanGiOGE2tZE5ylmB
         hvO860BMAie8ELdixylfGNQfcqD8V2aFTuXkk=
Message-ID: <2c0942db0807171311hae9b3e7v811e024990b05fe4@mail.gmail.com>
Date: Thu, 17 Jul 2008 13:11:59 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Please pull ACPI updates
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <487FA24B.9060803@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716214516.GA10777@basil.nowhere.org>
	 <200807170011.12184.rjw@sisk.pl>
	 <200807161633.01375.jbarnes@virtuousgeek.org>
	 <487EEAEB.4050009@firstfloor.org>
	 <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>
	 <487F71E8.9050705@firstfloor.org>
	 <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com>
	 <487FA24B.9060803@firstfloor.org>
X-Google-Sender-Auth: f747603d895a512c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 12:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Why would you care about the merge and not about the individual patches?
> Note that these quilt merges don't have conflicts.

Because sometimes merges are non-trivial. If you roll that merge
conflict resolution back into the original patch, then the patch is
now different. And in all these rebasings, who's to say there won't be
a typo that accidentally changes the original patch that has had more
testing? We'er all human, y'know?

>> It's the difference between having tested patches and an untested
>> merge, or untested new patches
>
> The patches are as tested individually as they were before. I don't see
> how you can call something that was in linux-next for some time and also
> in my test tree "untested".

Surely you agree that more testing is better? A rebased patch has had
less testing than the original patch, by definition.

> The completely merged tree is not tested
> well [1] in both cases (unless after some time of course) as far as I can see,
> no difference.
>
> [1] I do some basic testing as in building and test booting on a few
> machines on each merge, so calling it completely untested is not
> true.

Andi, no offense was intended here. I'm just asking you to walk
through a thought experiment with me, okay?

>> and an untested merge.
>
> So when I do a rebase versus Linus doing a merge (end result
> the same code base) how is that more untested?

If you rebase, you're creating new patches that have less testing than
the originals. You're also tossing away a history of the changesets,
which means that any external testers can no longer point to a
historical potion of a tree and say "I tested that".

Maybe the merging is trivial in all the cases you've hit so far,
great. What happens when it isn't? That's the larger point here.

>> Your point is
>> the end result is untested either way. The other way to look at it is
>> *how much* untested history ends up in the tree. In Linus' version,
>> just the point from the merge onward is untested. In your version,
>> everything is new.
>
> Sorry I still don't see the difference. AFAIK the only difference
> is that I do the merge vs Linus doing it and that it looks slightly
> different in the history, but apart from that (as in what
> actually ends up in the source tree) it's all the same.

Uhm, the history is the whole point of using source control and git.
If all we cared about was the end result and not the history, there'd
be little point to using source management other than to help speed
merging.
