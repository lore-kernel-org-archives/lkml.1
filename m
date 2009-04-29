Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZD2Df0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZD2Df0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZD2DfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:35:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:41696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZD2DfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:35:11 -0400
Message-ID: <49F7CA9A.5000701@kernel.org>
Date: Tue, 28 Apr 2009 20:33:46 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: ses check name in enclosure_component_register
References: <49F6678D.3080207@kernel.org> <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com> <49F7979A.8040302@kernel.org> <1240964289.3380.73.camel@mulgrave.int.hansenpartnership.com> <49F7A71F.5040709@kernel.org> <20090429020331.GF21648@parisc-linux.org>
In-Reply-To: <20090429020331.GF21648@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Apr 28, 2009 at 06:02:23PM -0700, Yinghai Lu wrote:
>> dev_set_name(cdev, name);
>>
>> the name become fmt. 
> 
> Yes, and what happens if 'name' is '%s'?
> 

change
dev_set_name(cdev, name);
to
dev_set_name(cdev, "%s", name);

didn't fix the problem.

need to check name && name[0]

YH
