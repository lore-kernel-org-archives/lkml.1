Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbYBSTza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbYBSTza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYBSTzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:55:17 -0500
Received: from [90.184.2.114] ([90.184.2.114]:17491 "EHLO mail.jaquet.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbYBSTzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:55:15 -0500
Date: Tue, 19 Feb 2008 20:55:13 +0100
From: Rasmus Andersen <rasmus@avlebavle.dk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LILO fatal error after going from 2.6.22 to 2.6.24.2
Message-ID: <20080219195513.GA25217@avlebavle.dk>
References: <20080219070201.GA7353@avlebavle.dk> <47BB1053.60409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BB1053.60409@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:22:27AM -0800, H. Peter Anvin wrote:
> Rasmus Andersen wrote:
[...]
> You have at least one file on a device mapper device (possibly an LVM 
> module), and LILO doesn't understand it.

Hi Peter, and thanks for your reply. That was indeed the issue, my /boot
was not mounted and my / is on a LVM partition. So this was merely a
user issue, my specialty.

Thanks for your time.

Cheers,
  Rasmus
