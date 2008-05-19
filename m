Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYETEFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYETEFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYETEFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:05:05 -0400
Received: from main.gmane.org ([80.91.229.2]:50783 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbYETEFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:05:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: John R Moser <nigelenki@comcast.net>
Subject: UML and VMI ... how does UML work?
Date: Mon, 19 May 2008 23:58:40 +0000 (UTC)
Message-ID: <loom.20080519T235035-223@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 199.173.224.31 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9b5) Gecko/2008032620 Firefox/3.0b5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been googling around but can't find a good resource for technically how UML
works.  I'm thinking about specifically the task of implementing a
virtualization platform without kernel hooks... this lead me to dancing around
checking out existing technology and noticing claims that UML can run on an
unmodified kernel without special needs.

In short, I'm curious about how UML works because I'm interested in knowing if
it's theoretically possible to remove the UML code (i.e. compile it out) and
then boot a kernel within an application that gives it a VMI structure to ...
act exactly as UML.

I know, it's probably really hard to have an application with no kernel
assistance actually load a kernel and expose a VMI API to it in the first place;
I'm not interested in X can't happen because Y can't happen, I'm just interested
in understanding the field.

