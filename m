Return-Path: <linux-kernel-owner+w=401wt.eu-S935708AbXHHO4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935708AbXHHO4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761472AbXHHOzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:55:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:59430 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbXHHOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=otLKNkZMhypMh1v6+7vLcmv3naJcHmIRHWdouc0pNOC/0xP0BcRCS/XpERPtbtwr1b+2hMHXBERh4ROTtF6doWC2Rdp69aVXPwPmqNfqcKFe3tjjWrzkqLUCBYKbnjdWVY7n4QF2MqE4lb/D2C8M6UJqW1J+/eGADKUhuynRjZM=
Message-ID: <46B9D961.4000902@gmail.com>
Date: Wed, 08 Aug 2007 23:55:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>	<20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>	<46B9D4B8.4050201@gmail.com> <20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 08 Aug 2007 23:35:36 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Does the attached patch happen to fix the problem?
> 
> Indeed it does; thanks!

Yeah, you seem to have 32bit off_t.  UINT_MAX overflows, so...

-- 
tejun
