Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXKLIST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXKLIST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 03:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXKLISH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 03:18:07 -0500
Received: from sa8.bezeqint.net ([192.115.104.22]:39145 "EHLO sa8.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbXKLISG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 03:18:06 -0500
Message-ID: <47380C33.8010103@panasas.com>
Date: Mon, 12 Nov 2007 10:17:55 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
References: <4732E6BA.8060001@panasas.com> <4733323D.4070309@redhat.com>
In-Reply-To: <4733323D.4070309@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov. 08, 2007, 17:58 +0200, Chris Snook <csnook@redhat.com> wrote:
> Benny Halevy wrote:
>> Greetings,
>>
>> I would like to hear peoples opinion about the indentation convention
>> described below that I personally found the most practical with
>> several different editors.
>>
>> The gist of it is that tabs should be used for nesting, not for decoration.
>> Indent your code with as many tabs as your nesting level, where all statements
>> will begin, and from there on use space characters.
>> The rational behind it is to be tab-width agnostic so regardless of your
>> tab expansion setup, the code will look correct and will make sense.
>>
>> When you break a line and want the new line text to start below a specific point
>> relative to the previous line (I consider that "decorating") then start the new
>> line with the same number of tabs as the previous one and then just use space
>> characters as their width is the same as any character in the previous line,
>> (assuming fixed-width fonts of course).
> 
> I find it meaningful to indent extended lines one extra tab stop, but beyond 
> that I agree it is just decoration.

Yup, that's a valid convention, as long as there are no trailing spaces after that
extra tab stop.  Concatenating spaces to this one extra tab stop (as checkpatch
allows for up to 7 spaces) for decoration works well just as long as everybody
expand tabs the same way.

Benny

> 
> 	-- Chris
> -

