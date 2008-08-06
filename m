Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbYHFJsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbYHFJsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYHFJpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:45:14 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:48898 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbYHFJpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:45:13 -0400
In-Reply-To: <200808060408.05272.nickpiggin@yahoo.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for	on
 access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 10:44:22 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 10:45:10,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 10:45:10,
	Serialize complete at 06/08/2008 10:45:10,
	S/MIME Sign failed at 06/08/2008 10:45:10: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 10:44:23,
	Serialize complete at 06/08/2008 10:44:23
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806094515.A6524316920@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote on 05/08/2008 19:08:05:

> On Tuesday 05 August 2008 07:00, Eric Paris wrote:
> > 5. Define which filesystems are cacheable and which are not
> 
> This is practically impossible to do completely without rewriting a lot
> of code (which will never be accepted). I don't see why it is needed 
though
> as the filesystem cache is supposed to be kept coherent with disk.

Problem is with network filesystems. So could it be a flag somewhere per 
filesystem which would say something like "this filesystem guarantees 
content of a file cannot change without get_write_access or 
file_update_time being called locally"? That doesn't sound like a lot of 
code so what am I missing?

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

