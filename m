Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbYFUOFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbYFUOFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYFUOEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:04:54 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:4092 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYFUOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:04:54 -0400
To: "Eric Smith" <eric@brouhaha.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Any lightweight way for one thread to force another thread to  suspend execution?
From: Andi Kleen <andi@firstfloor.org>
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
Date: Sat, 21 Jun 2008 16:04:51 +0200
In-Reply-To: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com> (Eric Smith's message of "Fri, 20 Jun 2008 16:54:39 -0700 (PDT)")
Message-ID: <877iciyjcs.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jun 2008 13:57:36.0010 (UTC) FILETIME=[C26E4EA0:01C8D3A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Eric Smith" <eric@brouhaha.com> writes:
>
> What I've thought about so far (but haven't tested) for thread A
> to suspend thread B is to use a signal and two pthread conditions:

Any such mechanism will need a syscall, and it's unlikely that
any syscall will get much cheaper than a kill(SIGSTOP) 

-Andi
