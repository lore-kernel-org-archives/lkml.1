Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbXFRQ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbXFRQ5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbXFRQ5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:57:15 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbXFRQ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:57:14 -0400
Message-ID: <4676B947.4010707@zytor.com>
Date: Mon, 18 Jun 2007 09:56:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: Bryan Henderson <hbryan@us.ibm.com>, alan <alan@clueserver.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <OFC119F96F.A721E445-ON882572FE.0055140A-882572FE.00571482@us.ibm.com> <4676B4B9.9030002@hawkeye.stone.uk.eu.org>
In-Reply-To: <4676B4B9.9030002@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
>>
>> Later, I discovered what I think are superior alternatives:  RCS-style 
>> version management on top of the filesystem, and automatic versioning 
>> based on time instead of count of "modifications."  For example, make a 
>> copy of every changed file every hour and keep it for a day and keep one 
>> of those for a week, and keep one of those for a month, etc.  This works 
>> even without snapshot technology and even without sub-file deltas.  But of 
>> course, it's better with those.
> 
> From what I can see this seems to be the consesus (and it sound very
> sensible to me).
> 
> The question remains is where to implement versioning: directly in
> individual filesystems or in the vfs code so all filesystems can use it?
> 

More likely a shim filesystem on top would be a better option.

	-hpa
