Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbYJQQKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbYJQQKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYJQQKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:10:01 -0400
Received: from styx.suse.cz ([82.119.242.94]:35468 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755065AbYJQQKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:10:01 -0400
Date: Fri, 17 Oct 2008 18:09:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: fix hidraw_exit section mismatch
In-Reply-To: <1224259488-11467-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0810171809390.28536@jikos.suse.cz>
References: <1224259488-11467-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Jiri Slaby wrote:

> hidraw_exit() marked as __exit is called from __init function
> from HID core. Remove the section placement from that function.

Thanks, applied.

-- 
Jiri Kosina
SUSE Labs
