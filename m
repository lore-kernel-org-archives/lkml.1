Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbXEEQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbXEEQT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbXEEQT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:19:27 -0400
Received: from smtp.nokia.com ([131.228.20.173]:42846 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbXEEQT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:19:26 -0400
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Florin Malita <fmalita@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
References: <463A04A5.5030103@gmail.com>
	 <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
	 <463BC019.40305@gmail.com>
	 <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 05 May 2007 15:09:19 +0300
Message-Id: <1178366959.3659.95.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 May 2007 12:09:19.0570 (UTC) FILETIME=[35A57B20:01C78F0E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 09:25 +0530, Satyam Sharma wrote:
> Again, I saw that too, but would still prefer using the higher level
> function ubi_scan_add_to_list() to add to the corrupted list, but with
> a different identifier for the return value to avoid overwriting err.
> list_add_tail seems best left as an implementation detail below
> ubi_scan_add_to_list(), IMO. So if it fails in the error path, we'd
> have to return with the original (write error) return value and the
> ENOMEM sort of goes ... unreturned. Alas!

I've put the fix here:
http://git.infradead.org/?p=users/dedekind/ubi-2.6.git;a=commit;h=5125237efb6a3309fbf5b9a7a21aaf716787f2a2

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

