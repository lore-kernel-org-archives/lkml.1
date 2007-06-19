Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbXFSXf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbXFSXf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbXFSXft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:35:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52576 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbXFSXfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:35:48 -0400
In-Reply-To: <20070619204317.GR10008@csclub.uwaterloo.ca>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: akpm@linux-foundation.org, alan <alan@clueserver.org>,
       Chris Snook <csnook@redhat.com>, hpa@zytor.com,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
MIME-Version: 1.0
Subject: Re: Versioning file system
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF35839FC7.229AE944-ON882572FF.007F2DF8-882572FF.00819E1C@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Tue, 19 Jun 2007 16:35:50 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V80_M5_05202007|May 20, 2007) at
 06/19/2007 19:35:48,
	Serialize complete at 06/19/2007 19:35:48
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>We don't need a new special character for every 
>>  new feature.  We've got one, and it's flexible enough to do what you 
want, 
>> as proven by NetApp's extremely successful implementation.

I don't know NetApp's implementation, but I assume it is more than just a 
choice of special character.  If you merely start the directory name with 
a dot, you don't fool anyone but 'ls' and shell wildcard expansion.  (And 
for some enlightened people like me, you don't even fool ls, because we 
use the --almost-all option to show the dot files by default, having been 
burned too many times by invisible files).

I assume NetApp flags the directory specially so that a POSIX directory 
read doesn't get it.  I've seen that done elsewhere.

The same thing, by the way, is possible with Jack's filename:version idea, 
and I assumed that's what he had in mind.  Not that that makes it all OK.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

