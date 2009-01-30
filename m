Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZA3Fy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZA3Fy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 00:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZA3Fyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 00:54:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:20094 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZA3Fyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 00:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s2Rehyes3JyreCWVFUzmkBAgrFsNn1MuKZU7sYpVT9so4yaD/yS1xDqcUS3RWgxBQc
         l17S1JvK/dgS7PZPGVgWSmTNxLx9xC/5a8iYsgxr03QPx6XqeHJYEzLk/hO8gYQD7pzy
         jLypdlxjQ5QG1pdeU7evNu8aazSX3C2oojEI8=
MIME-Version: 1.0
In-Reply-To: <1233138229-12489-7-git-send-email-rydberg@euromail.se>
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>
	 <1233138229-12489-2-git-send-email-rydberg@euromail.se>
	 <1233138229-12489-3-git-send-email-rydberg@euromail.se>
	 <1233138229-12489-4-git-send-email-rydberg@euromail.se>
	 <1233138229-12489-5-git-send-email-rydberg@euromail.se>
	 <1233138229-12489-6-git-send-email-rydberg@euromail.se>
	 <1233138229-12489-7-git-send-email-rydberg@euromail.se>
Date: Fri, 30 Jan 2009 14:54:48 +0900
Message-ID: <4e1455be0901292154k20dd6f47i643d274fe52a7e16@mail.gmail.com>
Subject: Re: [PATCH 6/6] input: Add a detailed multi-touch finger data report 
	protocol (rev2)
From: Joon Young Shim <dofmind@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Henrik Rydberg <rydberg@euromail.se>:
> In order to utilize the full power of the new multi-touch devices, a
> way to report detailed finger data to user space is needed. This patch
> adds a multi-touch (MT) protocol which allows drivers to report details
> for an arbitrary number of fingers.
>
> The driver sends a SYN_MT_REPORT event via the input_mt_sync() function
> when a complete finger has been reported.
>
> In order to stay compatible with existing applications, the data
> reported in a finger packet must not be recognized as single-touch
> events. In addition, all finger data must bypass input filtering,
> since subsequent events of the same type refer to different fingers.
>
> A set of ABS_MT events with the desired properties are defined. The
> events are divided into categories, to allow for partial implementation.
> The minimum set consists of ABS_MT_TOUCH_MAJOR, ABS_MT_POSITION_X and
> ABS_MT_POSITION_Y, which allows for multiple fingers to be tracked.
> If the device supports it, the ABS_MT_WIDTH_MAJOR may be used to provide
> the size of the approaching finger. Anisotropy and direction may be
> specified with ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and
> ABS_MT_ORIENTATION. Devices with more granular information may specify
> general shapes as blobs, i.e., as a sequence of rectangular shapes
> grouped together by a ABS_MT_BLOB_ID. Finally, the ABS_MT_TOOL_TYPE
> may be used to specify whether the touching tool is a finger or a pen.


Hi Henrik,

I want to know how calculates touch coordinates at user space using a
set of ABS_MT.
If i do dual touch, can i get correct two coordinates through ABS_MT report?


Joonyoung
