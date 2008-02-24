Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYBXOr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYBXOr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 09:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYBXOrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 09:47:45 -0500
Received: from lazybastard.de ([212.112.238.170]:54151 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYBXOro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 09:47:44 -0500
Date: Sun, 24 Feb 2008 15:47:11 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Page scan keeps touching kernel text pages
Message-ID: <20080224144710.GD31293@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While tracking down some unrelated bug I noticed that shrink_page_list()
keeps testing very low page numbers (aka kernel text) until deciding
that the page lacks a mapping and cannot get freed.  Looks like a waste
of cpu and cachelines to me.

Is there a better reason for this behaviour than lack of a patch?

Jörn

-- 
Joern's library part 11:
http://www.unicom.com/pw/reply-to-harmful.html
