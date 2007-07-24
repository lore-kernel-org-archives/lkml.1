Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbXGXTEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbXGXTEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbXGXTEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:04:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXGXTEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:04:43 -0400
Message-ID: <46A64C7F.5040508@zytor.com>
Date: Tue, 24 Jul 2007 12:01:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <20070724153916.GS21668@ftp.linux.org.uk> <46A62F35.2000501@goop.org> <20070724171455.GT21668@ftp.linux.org.uk> <46A636BB.7020706@zytor.com> <46A64BDD.4080309@goop.org>
In-Reply-To: <46A64BDD.4080309@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Could it be a gcc version difference?
>>   
> 
> Likely.  Well, we can always try it and see how much crap turns up.  If
> gcc keeps quiet about it, its certainly an improvement over the dummy loop.
> 
>     J

You could do both, actually.  If gcc sees the end without it, the loop
will simply get dead-code eliminated.

	-hpa
