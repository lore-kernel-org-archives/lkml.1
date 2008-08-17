Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYHQKr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYHQKr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 06:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHQKrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 06:47:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:53127 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYHQKrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 06:47:17 -0400
Date: Sun, 17 Aug 2008 03:46:27 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: rmeijer@xs4all.nl
cc: Peter Dolding <oiaohm@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       Eric Paris <eparis@redhat.com>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
      access scanning
In-Reply-To: <6746.82.95.100.23.1218969200.squirrel@webmail.xs4all.nl>
Message-ID: <alpine.DEB.1.10.0808170345300.12859@asgard.lang.hm>
References: <6746.82.95.100.23.1218969200.squirrel@webmail.xs4all.nl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008, Rob Meijer wrote:

> On Sun, August 17, 2008 10:58, david@lang.hm wrote:
>> On Sun, 17 Aug 2008, Peter Dolding wrote:
>>> Instead swap across to the shorter white list to process and sort.
>>> Quarantining for black list scanning so performance of machine is hit
>>> with the least ammount.  Some areas like email, p2p for people using
>>> formats that should not contain macros or executable code white list
>>> scanning there is all that is needed before either blocking or asking
>>> user if black list scanning should be preformed or the file just
>>> deleted.  Lets close the door's on these malware writers without hurt
>>> end users any more than we have to.  What is the point of running a full
>>> black list across a file the user will delete because it was not what
>>> they thought it was.
>>
>> you are arguing with the wrong people here. we are not trying to define
>> the future of anti-virus technologies, we are trying to figure out how to
>> provide the hooks so that people and companies can go off and do the
>> research and experimentation and try different approaches.
>
> Given recent demonstrations that show how easy it apparently is to bypass
> blacklist base approaches, providing hooks to allow these blacklist
> approaches may I feel be rather futile. Focusing only on hooks for white
> list approaches in combination with hooks for least authority approaches
> like the powerbox would IMHO seem like a much more reasonable approach
> given the current state of things and knowledge concerning the blacklist
> technologies. Explicitly adding support for technology that is quickly
> becoming obsolete would seem like a waste of time and resources.

we are not providing hooks for blacklists or whitelists, we are providing 
hooks for scanning. it's up to the software that doesn the scanning to 
implement the blacklist or whitelist.

David Lang
