Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbXF0A4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbXF0A4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXF0A4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:56:41 -0400
Received: from queue03-winn.ispmail.ntl.com ([81.103.221.57]:32417 "EHLO
	queue03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbXF0A4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:56:40 -0400
X-Greylist: delayed 1596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 20:56:40 EDT
Message-ID: <4681AF87.3000301@knosof.co.uk>
Date: Wed, 27 Jun 2007 01:29:59 +0100
From: Derek M Jones <derek@knosof.co.uk>
Organization: Knowledge Software, Ltd
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Neil Booth <neil@daikokuya.co.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
References: <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070626233226.GO7590@daikokuya.co.uk> <20070627001803.GJ21478@ftp.linux.org.uk>
In-Reply-To: <20070627001803.GJ21478@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:

>>> Hopefully correct handling of integer constant expressions.  Please, review.
>> Am I invoking sparse wrongly?  ./sparse -W -Wall doesn't diagnose
>> the following TU, for example.
>>
>> extern int a;
>> extern int as1[(a = 2)];
> 
> sparse simply doesn't check that.  We don't have anything resembling
> support of VLA.

If it did support VLAs it would point out that this is
a constraint violation.  VLAs must have block or function
prototype scope.

-- 
Derek M. Jones                              tel: +44 (0) 1252 520 667
Knowledge Software Ltd                      mailto:derek@knosof.co.uk
Applications Standards Conformance Testing    http://www.knosof.co.uk
