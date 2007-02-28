Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXB1O1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXB1O1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932784AbXB1O1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:27:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781AbXB1O1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:27:13 -0500
Message-ID: <45E5913D.3080505@redhat.com>
Date: Wed, 28 Feb 2007 09:27:09 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <andi@firstfloor.org>
Subject: Wanted: simple, safe x86 stack overflow detection
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can we just put a canary in the threadinfo and check it on every
task switch? What are the drawbacks?
