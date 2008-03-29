Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYC2Ryw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYC2Ryw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYC2Ryq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:54:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYC2Ryp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:54:45 -0400
Message-ID: <47EE8261.6010300@zytor.com>
Date: Sat, 29 Mar 2008 10:54:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Jacek Luczak <difrost.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
References: <47EE75A0.8070705@gmail.com> <47EE7A66.30905@zytor.com> <20080329172551.GA9785@ZenIV.linux.org.uk> <47EE7C3A.5000909@zytor.com> <20080329175227.GB9785@ZenIV.linux.org.uk>
In-Reply-To: <20080329175227.GB9785@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> 
> when you know there won't any additions past the last line (for that matter,
> ending it with
> 	Baz,
> 	Sentry_foo,
> 	Max_foo = Sentry_foo - 1
> }; is also an option, in which case the end of enum will never be touched
> at all).
> 

Yes, that's a very important exception.  Don't put the comma in if you 
want the set to be actively closed.

	-hpa
