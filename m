Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYGELi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYGELi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYGELiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:38:19 -0400
Received: from saeurebad.de ([85.214.36.134]:47242 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYGELiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:38:18 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] documentation: update CodingStyle tips for Emacs users
References: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
	<20080704134159.4dd9f74e@bike.lwn.net>
Date: Sat, 05 Jul 2008 11:36:44 +0000
In-Reply-To: <20080704134159.4dd9f74e@bike.lwn.net> (Jonathan Corbet's message
	of "Fri, 4 Jul 2008 13:41:59 -0600")
Message-ID: <878wwg4l6b.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jonathan Corbet <corbet@lwn.net> writes:

> On Fri, 04 Jul 2008 19:52:16 +0200
> Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> +(add-hook 'c-mode-hook
>> +          (lambda ()
>> +            (let ((filename (buffer-file-name)))
>> +              ;; Enable kernel mode for the appropriate files
>> +              (when (and file
>> +                         (string-match "/usr/src/linux" filename))
>
> Shouldn't that be "(and filename ..." rather than "file"?

Whoops, you are right.

> A test for /usr/src/linux seems misplaced, though; I don't think a
> whole lot of people keep their kernel trees there anymore.  There must
> be a better heuristic one can use to figure out whether a kernel source
> file is being edited.

Is this really needed?  I think most people have their kernel trees in
one directory and I used /usr/src/linux explicitely because it is so
well known and whoever reads this snippet knows what to substitute it
for.

But perhaps it should be "~/src/linux-trees/" to emphasize that it it
matches everything descendant from this directory.

A heuristics seems overkill as this snippet is not distributed code that
needs to be portable but it is just a tip for ones .emacs.  I don't want
heuristics in my .emacs if I know exactly where my kernel trees are.

But then, we should remove the check for linux-files completely and make
people use this coding style for every code they write ;)

	Hannes
