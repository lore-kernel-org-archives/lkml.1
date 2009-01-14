Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbZANIal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbZANIal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbZANIac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:30:32 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:35856 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756574AbZANIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:30:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAHcwbUnCTtAn/2dsb2JhbACBbMtWhW8
Date: Wed, 14 Jan 2009 09:30:24 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: linux kernel without file system
Message-ID: <20090114083024.GA30573@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I need to design a very small embedded system that must only control
one ethernet port and two serial lines and must fit in a very small flash
memory.  So I thought about replacing the call to /etc/init by my application
program and removing all the file-system part of linux.

Is that doable ?

Is there a 'standard' way of doing that ?

The first problem I see is accessing my serial lines.  How could I do that
without using open("/dev/ttySx"), which requires a file system ?

Is there a way to access devices that does not require a file-system ?

Thanks for reading this far

Philippe
