Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbYEAVXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbYEAVXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYEAVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:23:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547AbYEAVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:23:42 -0400
Date: Thu, 1 May 2008 14:23:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Message-Id: <20080501142305.77433e50.akpm@linux-foundation.org>
In-Reply-To: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 May 2008 17:56:02 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> megaraid_sas suspend and resume are inappropriatelly placed in
> __devinit section.

That's a box-killer, isn't it?

