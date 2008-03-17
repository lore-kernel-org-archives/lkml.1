Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbYCQSg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbYCQSg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYCQSgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:36:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:12895 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbYCQSgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:content-type;
        b=uqgTbZvMOF9kC3rlN94KdfZZpOyZZ3mNEMlIXVmCVGIrFbSKz9F7a01rhp5S8TiyHUp3RU89v44scHbrIqnzNgemZDpAWevKs0DUZPbUgy8A88+fGgmFccrkFka4lICEnOBBlIbdUXNy4D4BFxL79+qj7kgOu48DVFC3ACishgA=
Message-ID: <47DEBA37.6070408@gmail.com>
Date: Mon, 17 Mar 2008 19:36:39 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
CC: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: linux+glibc memory allocator, poor performance
References: <47D81D6E.9080701@gmail.com>
In-Reply-To: <47D81D6E.9080701@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040207010809040306070005"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040207010809040306070005
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Xose Vazquez Perez wrote:

> Poor performance with 2.6.24 linux kernel and glibc 2.7 provided by 
> Fedora 8:
> 
> *Memory allocation performance on FreeBSD and Linux with ebizzy (Mar 2008)*
> <http://people.freebsd.org/~kris/scaling/ebizzy.html>

Definitely it looks like a glibc bug: http://www.kernel.org/pub/linux/kernel/people/npiggin/ebizzy/
This time google libc does not help, but jemalloc did it.

yellow color(attached png) freeBSD vs. gnu malloc both in LiNUX.


-thanks for test it Nick-

regards,
-- 
so much to do, so little time.

--------------040207010809040306070005
Content-Type: image/png;
 name="ebizzy2.png"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="ebizzy2.png"

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
--------------040207010809040306070005--
