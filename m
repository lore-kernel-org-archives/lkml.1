Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYFDJhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYFDJhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYFDJhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:37:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:18025 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYFDJhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=FQ7OgOC3RAOxzpYEaWK0iBZ/aG9mz8RrJHexFTX11c3z2s+AbgMcsyiA7PcyN0UaWW
         LX6rA2dS+y2H01ALx5N9K1Z/RHRome0sR6daL/LdZFqgOF4SAwnV7sWqJL8FRX+3Drlc
         EOx5mvzA3EINb0LfvPvhC+ETqPOG30fAbEDXw=
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       squashfs-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Squashfs-devel] Squashfs mainlining status?
References: <Pine.LNX.4.64.0806021650190.28709@vixen.sonytel.be>
	<48460906.2080205@lougher.demon.co.uk>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Wed, 04 Jun 2008 11:37:34 +0200
In-Reply-To: <48460906.2080205@lougher.demon.co.uk> (Phillip Lougher's message of "Wed\, 04 Jun 2008 04\:16\:22 +0100")
Message-ID: <87od6h7d7l.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Phillip" == Phillip Lougher <phillip@lougher.demon.co.uk> writes:

Hi,

 Phillip> I am currently working on this.  A re-write and merge of the
 Phillip> Squashfs metadata and fragment cache code has been finished
 Phillip> (it is in the Squashfs CVS tree).  The original
 Phillip> implementation had a number of performance issues which I
 Phillip> wanted to address before resubmission.

Nice to hear! Are you aiming for 2.6.27 or later?

 Phillip> The major work of course is the move to a little endian
 Phillip> layout without any bit fields in the structures to make it
 Phillip> easier to swap member fields on big-endian architectures.
 Phillip> I'm currently working on this on a non-CVS branch.
 Phillip> Most of the work till now has been without any attempt to
 Phillip> retain backwards compatibility with the current 3.3
 Phillip> little-endian filesystem layout.  After your private email
 Phillip> regarding retaining backwards compatibility I will look
 Phillip> again at this issue, it may well be that I will abandon my
 Phillip> current layout changes that I have so far made.

What private mail? Anything of interest to the rest of the group? As I
said earlier, I'm strongly in faviour of cleaning up the layout now
and get rid of all the backwards compatibility code. Doing it once
it's in mainline will be really hard.

 Phillip> I have taken time off work to work on the necessary mainline
 Phillip> changes full time (unpaid unfortunately, so I need to look
 Phillip> for another job soon).  Hopefully this will mean I will make
 Phillip> better progress than I have been able to in the last couple
 Phillip> of years.

;) Good luck with it. Is there anything I can do to help?

-- 
Bye, Peter Korsgaard
