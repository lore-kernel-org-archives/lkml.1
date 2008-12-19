Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYLSRIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYLSRIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYLSRI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:08:26 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:9943 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYLSRIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:08:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kviPns1N+HNPl9J9Fj+wTnLFBu7N36gLOHhxzp3sV+SnoHCn/Qv+V+ZHq9eLmLRpEv
         W/+0SOGibesLlNvwDKR4SFCu1E7zxD2VlaBRGZtnzspfZm3TNpUm4DYICqFd32w83DiF
         GUZvLeT8PGngCzi1pTbvS8UKxjtjpXjJxBK1M=
Message-ID: <c6d9bea0812190908k223b6156j238763baeda8a0b7@mail.gmail.com>
Date: Fri, 19 Dec 2008 12:08:22 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Michael J Gruber" <git@drmicha.warpmail.net>
Subject: Re: [PATCH] Simplified GIT usage guide
Cc: "David Howells" <dhowells@redhat.com>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <494B68B8.20107@drmicha.warpmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
	 <c6d9bea0812181647n55fbb6b9w333702fc80127198@mail.gmail.com>
	 <494B68B8.20107@drmicha.warpmail.net>
X-Google-Sender-Auth: 0bceeb69eff1a97e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 4:26 AM, Michael J Gruber
<git@drmicha.warpmail.net> wrote:
> C. Scott Ananian venit, vidit, dixit 19.12.2008 01:47:
>> On Fri, Dec 12, 2008 at 1:28 PM, David Howells <dhowells@redhat.com> wrote:
>>> Add a guide to using GIT's simpler features.
>>> diff --git a/Documentation/git-haters-guide.txt b/Documentation/git-haters-guide.txt
>>> +In the above example, I've assumed that you've got your own tree with the head
>>> +at commit C3, and that you've got a branch that you want to merge, which has
>>> +its head at commit B3.  After merging them, you'd end up with a directed,
>>> +cyclic tree:
>>
>> That should be, "acyclic".  There are no cycles, because the graph is directed.
>
> Well, directed graphs can have cycles. But the revision graph of a
> revision control system has to be an acyclic directed graph. Otherwise
> parenthood would be a complicated matter ;)

I mean that the example given didn't have a cycle (even though it has
nodes arranged in a circle) because of the orientation of the edges.
But you're right, "directed acyclic graph" is a better correction; the
nodes in git do not form a tree.
 --scott

-- 
                         ( http://cscott.net/ )
