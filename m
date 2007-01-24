Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbXAXOWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbXAXOWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXAXOWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:22:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbXAXOWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:22:46 -0500
Message-ID: <45B76BAC.4040408@redhat.com>
Date: Wed, 24 Jan 2007 09:22:36 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] i_ino uniqueness: alternate approach -- hash the
 inodes
References: <200701161857.l0GIvcaA016196@dantu.rdu.redhat.com> <20070123204648.204b1834.akpm@osdl.org>
In-Reply-To: <20070123204648.204b1834.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> What is the additional overhead, expressed in relative terms?  ie: as a percentage?

Short answer: ~3-4% in a not very scientific test.

Long answer: I timed 3 different runs of a program that created and then closed 
a pipe 10 million times on a patched and unpatched kernel. I then added up the
"system" times for each and divided them:

unpatched:
sys     1m53.959s
sys     1m56.083s
sys     1m48.055s

patched:
sys     1m56.899s
sys     1m57.027s
sys     1m57.031s

The result was 1.03803642150033866020.

-- Jeff
