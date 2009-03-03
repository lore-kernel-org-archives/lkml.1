Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZCCVwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZCCVwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZCCVvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:51:54 -0500
Received: from hera.cwi.nl ([192.16.191.8]:33415 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbZCCVvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:51:53 -0500
Date: Tue, 3 Mar 2009 22:51:26 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Mike Snitzer <snitzer@gmail.com>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: ext3 duplicate entries with readdir
Message-ID: <20090303215122.GB20640@ub>
References: <20090303200526.GA20236@ub> <170fa0d20903031254l7070294cwfa45ffdcc63b24d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20903031254l7070294cwfa45ffdcc63b24d9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 03:54:02PM -0500, Mike Snitzer wrote:
> On Tue, Mar 3, 2009 at 3:05 PM, Andries E. Brouwer wrote:
>
>> In a largish directory (21292 files) a scan using ext3 readdir
>> found 21293 files, returning one entry twice.
>>
>> Has this been fixed in the current tree?
> 
> Yes, it has been fixed, please see the following git commits:
>
> 6a897cf447a83c9c3fd1b85a1e525c02d6eada7d
> 8c9fa93d51123c5540762b1a9e1919d6f9c4af7c

Good, thanks!

Andries


[On another machine, Ubuntu with 2.6.27-7-server still fails:
% ../readdirtest
expected 61005 files, but readdir reports 61006
% rm *
rm: cannot remove `59992': No such file or directory
(where the same name occurs twice in the expansion of *).]


