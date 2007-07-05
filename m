Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbXGEOC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbXGEOC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbXGEOCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:02:50 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:37063 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbXGEOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:02:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.63700.223173.537189@stoffel.org>
Date: Thu, 5 Jul 2007 09:57:40 -0400
From: "John Stoffel" <john@stoffel.org>
To: Erik Mouw <mouw@nl.linux.org>
Cc: Theodore Tso <tytso@mit.edu>, alan <alan@clueserver.org>,
       J?rn Engel <joern@logfs.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <20070704173234.GB26201@gateway.home>
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
	<467314E2.9010306@zytor.com>
	<Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
	<20070616145337.GA13391@lazybastard.org>
	<20070618094524.GF5181@schatzie.adilger.int>
	<20070618140143.GD30244@thunk.org>
	<Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org>
	<20070618172955.GB24189@thunk.org>
	<20070704173234.GB26201@gateway.home>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Erik" == Erik Mouw <mouw@nl.linux.org> writes:

Erik> (sorry for the late reply, just got back from holiday)
Erik> On Mon, Jun 18, 2007 at 01:29:56PM -0400, Theodore Tso wrote:
>> As I mentioned in my Linux.conf.au presentation a year and a half ago,
>> the main use of Streams in Windows to date has been for system
>> crackers to hide trojan horse code and rootkits so that system
>> administrators couldn't find them.  :-)

Erik> The only valid use of Streams in Windows I've seen was a virus
Erik> checker that stored a hash of the file in a separate
Erik> stream. Checking a file was a matter of rehashing it and
Erik> comparing against the hash stored in the special hash data
Erik> stream for that particular file.

So what was stopping a virus from infecting a file, re-computing the
hash and pushing the new hash into the stream?  

You need to keep the computed hashes on Read-Only media for true
security, once you let the system change them, then you're toast....

John
