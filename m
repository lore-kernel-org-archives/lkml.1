Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYJ1DcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYJ1DcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYJ1Dbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:31:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbYJ1Dbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:31:52 -0400
Date: Mon, 27 Oct 2008 20:31:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/video_{de,en}coder.h: cleanup for userspace
Message-Id: <20081027203103.be272647.akpm@linux-foundation.org>
In-Reply-To: <1225018064-3312-1-git-send-email-vapier@gentoo.org>
References: <1225018064-3312-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 06:47:44 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> Make sure the linux/video_{de,en}coder.h header files include other header
> files that they use (for types and structures).
> 

checkpatch (amazing tool, and it's free!) said:

ERROR: Don't use <linux/videodev.h>: see Documentation/feature-removal-schedule.txt
#23: FILE: include/linux/video_decoder.h:5:
+#include <linux/videodev.h>

so I'll drop this one.


