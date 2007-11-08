Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbXKHKhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbXKHKhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbXKHKgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:36:55 -0500
Received: from sa2.bezeqint.net ([192.115.104.16]:58152 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761207AbXKHKgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:36:53 -0500
Message-ID: <4732E6BA.8060001@panasas.com>
Date: Thu, 08 Nov 2007 12:36:42 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Coding Style: indenting with tabs vs. spaces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I would like to hear peoples opinion about the indentation convention
described below that I personally found the most practical with
several different editors.

The gist of it is that tabs should be used for nesting, not for decoration.
Indent your code with as many tabs as your nesting level, where all statements
will begin, and from there on use space characters.
The rational behind it is to be tab-width agnostic so regardless of your
tab expansion setup, the code will look correct and will make sense.

When you break a line and want the new line text to start below a specific point
relative to the previous line (I consider that "decorating") then start the new
line with the same number of tabs as the previous one and then just use space
characters as their width is the same as any character in the previous line,
(assuming fixed-width fonts of course).

For example:

{
	if (very_long_expression &&
	    it_needs_to_be_broken_into_several_lines)
		return a_very_long_result +
		       the_remainder_of_it_that_spilled_off +
		       to_the_next_lines;

	return printk("just my %d cents\n",
	              2);
}

Thanks,

Benny

