Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbXITIsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbXITIsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXITIso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:48:44 -0400
Received: from sacred.ru ([62.205.161.221]:47836 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbXITIsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:48:43 -0400
Message-ID: <46F23351.2020003@openvz.org>
Date: Thu, 20 Sep 2007 12:46:09 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Rework /proc/locks via seq_files and seq_list helpers
 (v2)
References: <46F2330E.4040107@openvz.org>
In-Reply-To: <46F2330E.4040107@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Sep 2007 12:48:30 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Currently /proc/locks is shown with a proc_read function, but
> its behavior is rather complex as it has to manually handle
> current offset and buffer length. On the other hand, files 
> that show objects from lists can be easily reimplemented using
> the sequential files and the seq_list_XXX() helpers.
> 
> This saves (as usually) 16 lines of code and more than 200 from
> the .text section.
> 
> This patch looks rather ugly, as diff often uses curly braces
> as not-changed lines, but I haven't managed to organize the 
> code to make diff look better. Except for move the whole proc
> related stuff upper/lower in the locks.c file...
> 
> Fixed the problem, spotted by J. Bruce Fields, about the fl
> variable reuse.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

OOPS! Please disregard, wrong comment was copied :(
