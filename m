Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYJaUpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYJaUpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYJaUpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:45:04 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:62003 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYJaUpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:45:03 -0400
X-Greylist: delayed 1637 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2008 16:45:03 EDT
Date: Fri, 31 Oct 2008 20:17:45 +0000
From: Sean Young <sean@mess.org>
To: linux-kernel@vger.kernel.org
Cc: Joern Engel <joern@logfs.org>
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031201745.GA93714@atlantis.8hz.com>
References: <20081026124643.GA1328@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026124643.GA1328@logfs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 01:46:44PM +0100, Joern Engel wrote:
> General advantages of btrees are memory density and efficient use of
> cachelines.  Hashtables are either too small and degrade into linked
> list performance, or they are too large and waste memory.  With changing
> workloads, both may be true on the same system.  Rbtrees have a bad
> fanout of less than 2 (they are not actually balanced binary trees),
> hence reading a fairly large number of cachelines to each lookup.

Which reminds me:

find_vma() uses rbtrees. Now I assume find_vma() is called far more than
mmap() and friends. Since avltree are balanced (unlike rbtrees) lookups
will be faster at the expense of extra rotations during updates.

Would patches for avltrees be accepted?

Thanks
Sean
