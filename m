Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbXI0P3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbXI0P3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXI0P3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:29:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39536 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbXI0P3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:29:41 -0400
Date: Thu, 27 Sep 2007 16:29:38 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: mahamuni ashish <ash_lkp@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Floating Point Issue
Message-ID: <20070927152938.GV8181@ftp.linux.org.uk>
References: <109515.18343.qm@web7805.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <109515.18343.qm@web7805.mail.in.yahoo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 12:41:41PM +0100, mahamuni ashish wrote:
> I have small code....
> 
> #include <stdio.h>
> #include <string.h>
> 
> int main()
> {
> float f= 1256.35;
> char ch[4];
> 
> printf("\n1. f : %f",f);
> memset(ch,'\0',strlen(ch) );

strlen() applied to uninitialized array => undefined behaviour.

What does that have to do with the kernel, anyway?
