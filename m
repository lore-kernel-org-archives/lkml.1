Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbZK3NoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbZK3NoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZK3NoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:44:14 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63297 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbZK3NoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=sOgOlIw+WDzAubpdeQzQXMhhFu05ISYrnXiFLIE48Z5hxlm1PBVGI+FNUq0WXX2sl8
         kXpKQPpGrDkzZllh+rr3Lz/BDVX64xPpzy3Ot3T0iFkdlPR4BcqsRETw4EZDHbrgugiV
         yAb9t5dFzwq+HV4H2ulVVsrfMGJJKoso0lelI=
Date: Mon, 30 Nov 2009 13:44:14 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: warning: massive change to conditional coding style in net?
Message-ID: <20091130134414.GB7114@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B13A025.7000103@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-11-2009 11:36, William Allen Simpson wrote:
> Over the past several days, David Miller (with help from Joe Perches)
> made sweeping changes to the format of conditional statements in the
> net tree -- the equivalent of mass patches that change spaces.
> 
> This makes writing patches for multiple versions of the tree very
> difficult, and will make future pullups problematic.  It's enough to
> make a grown man cry....  Patching conflicts everywhere!
> 
> CodingStyle is mute on this issue.  Does Linus have a preference?
> 
> My personal practice (based on decades of open source projects) has
> been to use a form already used in the same file or section of code,
> matching the existing practice.
> 
> If this is to be done everywhere, CodingStyle (and SubmittingPatches)
> should be updated.
> 
> Currently, roughly 19% (7855 lines) of the -2.6 tree uses leading form:
> 
> 	if (condition
> 	    && condition
> 	    && (condition
> 	        || condition
> 	        || condition)) {
> 
> Single spaced is also fairly common:
> 
> 	if (condition
> 	 && condition
> 	 && (condition
> 	  || condition
> 	  || condition)) {
> 
> The advantage of the leading form is *readability* due to indentation,
> ease of patching and reading patches (changes affect only 1 line,
> instead of previous and following lines), and especially conditionals
> within #if sections.  Also, shorter lines (by 3 characters).
> 
> The other 81% uses trailing form, often with odd random line breaks:
> 
> 	if (condition &&
>              condition && (condition || condition ||
> 	    condition)) {
> 
> Miller (with Perches) changed hundreds (thousands?) of these to
> trailing form.  This results in a number of hilarious examples --
> lines with both leading and trailing, lines with only &&, etc.  A
> small sample for illustration:

Yes, it's even enough to make a grown man laugh....

Jarek P.
