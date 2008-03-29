Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYC2Rwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYC2Rwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYC2Rwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:52:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43300 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbYC2Rw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:52:29 -0400
Date: Sat, 29 Mar 2008 17:52:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacek Luczak <difrost.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
Message-ID: <20080329175227.GB9785@ZenIV.linux.org.uk>
References: <47EE75A0.8070705@gmail.com> <47EE7A66.30905@zytor.com> <20080329172551.GA9785@ZenIV.linux.org.uk> <47EE7C3A.5000909@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EE7C3A.5000909@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 10:28:26AM -0700, H. Peter Anvin wrote:
> Yes, it is.
> 
> I personally prefer it this way (strongly) for exactly the same reason C 
> requires a semicolon at the end of each statement, as opposed to Pascal 
> which doesn't require a semicolon immediately before an "end".

enum foo {
	Foo,
	Bar,
	Baz,
	Max_foo = Baz
};

when you know there won't any additions past the last line (for that matter,
ending it with
	Baz,
	Sentry_foo,
	Max_foo = Sentry_foo - 1
}; is also an option, in which case the end of enum will never be touched
at all).

enum {Some_constant = ...};

when you do not want to mix it with other constants and use a separate
enum for each natural group.

Sometimes it makes sense, sometimes it doesn't.  It is an expressive
element, not something to be cast in stone by Documentation/CodingStyle.
