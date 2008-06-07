Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYFGTlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYFGTlc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYFGTlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:41:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYFGTlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:41:23 -0400
Date: Sat, 7 Jun 2008 15:34:24 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: wrong hardlink count in /proc
Message-ID: <20080607193424.GA25998@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.25, 'find /proc/ -name foo' will print out ..

find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
in your filesystem driver.  Automatically turning on find's -noleaf
option.  Earlier results may have failed to include directories that
should have been searched.


	Dave

-- 
http://www.codemonkey.org.uk
