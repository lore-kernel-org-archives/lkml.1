Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbZANJev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbZANJev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbZANJed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:34:33 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:32412 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516AbZANJeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:34:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANdAbUnCTtAn/2dsb2JhbACBbMtRhW8
Date: Wed, 14 Jan 2009 10:34:22 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
Message-ID: <20090114093422.GA9771@frolo.macqel>
References: <496DA678.1090701@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496DA678.1090701@wpkg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 09:46:48AM +0100, Tomasz Chmielewski wrote:
>> I need to design a very small embedded system that must only control
>> one ethernet port and two serial lines and must fit in a very small flash
>> memory.  So I thought about replacing the call to /etc/init by my 
>> application
>> program and removing all the file-system part of linux.
>> Is that doable ?
>> Is there a 'standard' way of doing that ?
>> The first problem I see is accessing my serial lines.  How could I do that
>> without using open("/dev/ttySx"), which requires a file system ?
>> Is there a way to access devices that does not require a file-system ?
>
> You could put everything in initramfs (and embed it in the kernel).

Actually, I was thinking about reducing the footprint of my kernel by
removing all the fs-related system calls, so the problem is not where
the file-system is, but how to access (serial) devices without giving their
"/dev/..." name.

Thanks anyway

Philippe
