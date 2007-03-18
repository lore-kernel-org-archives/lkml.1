Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbXCRXNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbXCRXNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 19:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933405AbXCRXNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 19:13:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:26780 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbXCRXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 19:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gthI3gMNQTCKqV4jWLiYT0o6eb2g0f9tvNpMMQbpr78JPC7DpxgGNV1l5gSDlk8BXSsm9M+moFaj9Pz+uM1cmwqT6Un3vYK/fLSygWUyBMqQ4XdcFIsCuhp7oyeDZhhiZLgSXRF86SxnQIhBNvulS0DiIA5CAp4IrHNPBOScATE=
Message-ID: <21d7e9970703181613h7ed6625fl9ab7d05a56f4c998@mail.gmail.com>
Date: Mon, 19 Mar 2007 10:13:37 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: [patch 0/6] fault vs truncate/invalidate race fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>, npiggin@suse.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1172559262.11949.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221023656.6306.246.sendpatchset@linux.site>
	 <21d7e9970702262036h3575229ex3bf3cd4474a57068@mail.gmail.com>
	 <20070226213204.14f8b584.akpm@linux-foundation.org>
	 <21d7e9970702262226v6fc70e06jd759c66c383630e1@mail.gmail.com>
	 <1172559262.11949.47.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > the new fault hander made the memory manager code a lot cleaner and
> > very less hacky in a lot of cases. so I'd rather merge the clean code
> > than have to fight with the current code...
>
> Note that you can probably get away with NOPFN_REFAULT etc... like I did
> for the SPEs in the meantime.

Indeed, Thomas has done this work and I'm just lining up a TTM tree to
start the merge process..

Dave.
