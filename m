Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbYJ1DeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbYJ1DeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYJ1DeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:34:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:38717 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYJ1DeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LTU2XrhvOq9aiJL0SPxCMWteAe8kPZS/YNXLrTPO1gDjRane9hfxQBM+i8Uf1xJ/93
         c5n/S71lwmespxLr/+EWHeV2cwSXysrVO8hRZkGmgRFyfNvDg93G/dYlzF7+AbGfLuMb
         4SfQ3QDDBqQshqTViEu1oumPYbmJSyBP6PjoE=
Message-ID: <1aad82fa0810272034o22341562sbedcb098ba506bee@mail.gmail.com>
Date: Mon, 27 Oct 2008 23:34:03 -0400
From: "Mike Frysinger" <vapier@gentoo.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/video_{de,en}coder.h: cleanup for userspace
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081027203103.be272647.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225018064-3312-1-git-send-email-vapier@gentoo.org>
	 <20081027203103.be272647.akpm@linux-foundation.org>
X-Google-Sender-Auth: f08174348fb81cb3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:31 PM, Andrew Morton wrote:
> On Sun, 26 Oct 2008 06:47:44 -0400 Mike Frysinger wrote:
>> Make sure the linux/video_{de,en}coder.h header files include other header
>> files that they use (for types and structures).
>
> checkpatch (amazing tool, and it's free!) said:
>
> ERROR: Don't use <linux/videodev.h>: see Documentation/feature-removal-schedule.txt
> #23: FILE: include/linux/video_decoder.h:5:
> +#include <linux/videodev.h>
>
> so I'll drop this one.

maybe, but video_decoder.h def uses things in linux/videodev.h today.
if we add the include, hopefully it'll help people realize they need
to remove the relevant things from video_decoder.h as well.
-mike
