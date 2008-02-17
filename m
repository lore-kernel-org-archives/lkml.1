Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYBQVcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYBQVcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYBQVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:32:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYBQVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:32:33 -0500
Message-ID: <47B8A7B9.2060500@zytor.com>
Date: Sun, 17 Feb 2008 13:31:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B9AF.2030006@zytor.com> <47B7BC4C.8070502@oracle.com> <200802172140.16055.rjw@sisk.pl> <20080217210710.GA15284@uranus.ravnborg.org> <47B8A557.9080901@zytor.com> <20080217212838.GA15631@uranus.ravnborg.org>
In-Reply-To: <20080217212838.GA15631@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> But I assume in less obvious way.
> It is a bit more intuitive to error out on missing
> -m32 support than gcc failing to support .code16
> or some other inline assembler magic.
> 

No, you will get the message "the selected CPU doesn't support the 
x86-64 architecture".

	-hpa
