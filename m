Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYJPUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYJPUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 16:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYJPUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 16:52:23 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43687 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYJPUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 16:52:23 -0400
Message-ID: <48F7A971.3040500@nortel.com>
Date: Thu, 16 Oct 2008 14:52:01 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       jeffschroeder@computer.org
Subject: Re: [PATCH] use tmpfs for rootfs v2
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz> <Pine.LNX.4.64.0810161507130.25933@anakin> <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 20:52:02.0945 (UTC) FILETIME=[0A9C3710:01C92FD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:

> Having tmpfs as the root filesystem allows you to get rid of the now unused 
> ramfs and free some kernel memory. On my system, that's about 5198 bytes 
> compared to having a ramfs root.

If you're not using swap, I assume the memory usage of tmpfs and ramfs 
would be identical?

Chris
