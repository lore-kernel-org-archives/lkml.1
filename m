Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZCJRqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZCJRqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbZCJRqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:46:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48897 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414AbZCJRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:46:33 -0400
Date: Tue, 10 Mar 2009 18:46:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 00/31] *** SUBJECT HERE ***
Message-ID: <20090310184624.4e28d18e@hyperion.delvare>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 16:23:48 +0000, Scott James Remnant wrote:
> module-init-tools on most distributions ships with a file that contains a
> large list of aliases to auto-load modules on demand, either by matching
> a MODALIAS string from the kernel uevent, or by the {block,char}-major-*
> aliases requested by the kernel when device nodes are opened.
> 
> There are convenient macros for defining these inside the kernel modules
> themselves, so they are exported by file2alias and put into the files
> created by depmod.  This is far preferable to a file in another package
> that has to be parsed every time modprobe is called (many, many times
> on a typical boot) and may get out of date.

I don't get how it could make any difference in terms of performance.
As far as I know, all the module aliases that come from the kernel are
assembled into /lib/modules/$version/modules.alias when the kernel is
installed, and that file must be processed by modprobe the exact same
way another configuration file would. Or am I missing something?

-- 
Jean Delvare
