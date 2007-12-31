Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbXLaRcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbXLaRcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 12:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbXLaRb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 12:31:56 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:42638 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXLaRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:31:55 -0500
From: Junio C Hamano <gitster@pobox.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl>
	<476E42BF.1010300@garzik.org>
	<Pine.LNX.4.64.0712310349260.2093@fbirervta.pbzchgretzou.qr>
	<4778D1CD.4020001@s5r6.in-berlin.de>
Date: Mon, 31 Dec 2007 09:31:40 -0800
In-Reply-To: <4778D1CD.4020001@s5r6.in-berlin.de> (Stefan Richter's message of
	"Mon, 31 Dec 2007 12:26:05 +0100")
Message-ID: <7v4pdy7oub.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> Jan Engelhardt wrote:
>>> 	http://linux.yyz.us/git-howto.html
>> 
>> It says
>> 
>> """Don't forget to download tags from time to time.
>> 
>> git pull only downloads sha1-indexed object data, and the requested
>> remote head. This misses updates to the .git/refs/tags/ and
>> .git/refs/heads/ directories. For tags, run git fetch --tags $URL."""
>> 
>> But when I do git pull on a simple tracking tree (e.g. git-clone
>> torvalds/linux-2.6.git; git pull;) it automatically grabs new tags.
>
> A while ago the default behavior of git pull was changed to fetch all
> tags which point to objects that can be reached from any of the tracked
> heads.
>
> Old behaviour:  Option --tags was needed to fetch tags at all.  Current
> behavior:  Option --tags forces to download all tags and the objects
> they point to.  Option --no-tags works like the old default behavior.
>
> Readers of Kernel Hackers' Guide to git will most certainly have a
> recent enough version of git so that the "download_tags" subsection can
> be removed without replacement.

All correct.

That "A while ago" is quite a while ago, though.  IIRC it was
added very early in 2006, which is eons ago in git timescale.




