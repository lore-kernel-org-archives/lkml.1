Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbZANIr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbZANIr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZANIrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:47:15 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:47855 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZANIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:47:15 -0500
Message-ID: <496DA678.1090701@wpkg.org>
Date: Wed, 14 Jan 2009 09:46:48 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, phdm@macqel.be
Subject: Re: linux kernel without file system
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I need to design a very small embedded system that must only control
> one ethernet port and two serial lines and must fit in a very small flash
> memory.  So I thought about replacing the call to /etc/init by my application
> program and removing all the file-system part of linux.
> 
> Is that doable ?
> 
> Is there a 'standard' way of doing that ?
> 
> The first problem I see is accessing my serial lines.  How could I do that
> without using open("/dev/ttySx"), which requires a file system ?
> 
> Is there a way to access devices that does not require a file-system ?

You could put everything in initramfs (and embed it in the kernel).


-- 
Tomasz Chmielewski
http://wpkg.org
