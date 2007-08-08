Return-Path: <linux-kernel-owner+w=401wt.eu-S935694AbXHHPMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935694AbXHHPMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934907AbXHHPMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:12:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33678 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934803AbXHHPMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:12:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>
	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>
	<20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>
	<46B9D4B8.4050201@gmail.com>
	<20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>
	<46B9D961.4000902@gmail.com>
Date: Wed, 08 Aug 2007 09:08:38 -0600
In-Reply-To: <46B9D961.4000902@gmail.com> (Tejun Heo's message of "Wed, 08 Aug
	2007 23:55:29 +0900")
Message-ID: <m1r6medpxl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Cornelia Huck wrote:
>> On Wed, 08 Aug 2007 23:35:36 +0900,
>> Tejun Heo <htejun@gmail.com> wrote:
>> 
>>> Does the attached patch happen to fix the problem?
>> 
>> Indeed it does; thanks!
>
> Yeah, you seem to have 32bit off_t.  UINT_MAX overflows, so...

Weird.  And we have it opening the directory O_LARGEFILE.

I have no problems with the fix though.

Eric
