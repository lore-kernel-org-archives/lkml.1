Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbXFSUfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbXFSUfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbXFSUfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:35:06 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:36453 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbXFSUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:35:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18040.15842.698982.608861@stoffel.org>
Date: Tue, 19 Jun 2007 16:34:42 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
In-Reply-To: <467837AB.4030607@hawkeye.stone.uk.eu.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
	<4673182B.4090800@redhat.com>
	<46739E89.1080003@hawkeye.stone.uk.eu.org>
	<46781A5B.9090104@redhat.com>
	<4678292B.6000804@hawkeye.stone.uk.eu.org>
	<4678369C.7070908@redhat.com>
	<467837AB.4030607@hawkeye.stone.uk.eu.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jack" == Jack Stone <jack@hawkeye.stone.uk.eu.org> writes:

Jack> The whole idea of the file system is that it wouldn't return the
Jack> file in the file listing. The user would have to know that the
Jack> file system was versioning to access the older versions as they
Jack> would explicitly have to request them.

So tell me what happens when I do:

	touch foo:121212121212

