Return-Path: <linux-kernel-owner+w=401wt.eu-S934740AbXK3PmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740AbXK3PmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbXK3Pl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:41:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:35636 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbXK3Pl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:41:56 -0500
Cc: linux-kernel@vger.kernel.org
Message-Id: <0832B42A-F392-497D-9F3B-4481AFFE2679@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Dave Jones <davej@redhat.com>
In-Reply-To: <20071130152837.GA8116@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: git + checkpatch.pl?
Date: Fri, 30 Nov 2007 09:41:24 -0600
References: <DF3E6A31-61AA-44B2-90C0-7001976E5691@kernel.crashing.org> <20071130152837.GA8116@redhat.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 30, 2007, at 9:28 AM, Dave Jones wrote:

> On Fri, Nov 30, 2007 at 09:18:59AM -0600, Kumar Gala wrote:
>> Does any know if there is a way to run checkpatch.pl over the index
>> before one does a commit?
>
> git diff | scripts/checkpatch.pl

thanks.  I think I want:

git-diff HEAD | scripts/checkpatch.pl --no-signoff -

but the general idea works.  (need more sleep)

- k
