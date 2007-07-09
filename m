Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXGIUW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXGIUW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbXGIUWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:22:20 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:48343 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbXGIUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:22:19 -0400
Message-ID: <469298F5.9090301@fr.ibm.com>
Date: Mon, 09 Jul 2007 22:22:13 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/16] Miscelaneous preparations for namespaces
References: <468DF6F7.1010906@openvz.org> <468DF76A.7060106@openvz.org>
In-Reply-To: <468DF76A.7060106@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> The most importaint change is moving exit_task_namespaces()
> inside exit_notify() to makes it possible to notify the
> exiting task's parent. However this should be done before
> release_task() to address the issue pointed by Sukadev with
> NFS kernel thread.

Have you actually checked that doing an unshare() with a NFS mount ?
 
> Other changes are small and do not deserve separate description.

yes. if they were in a separate patch, you could push them to -mm.

thanks,

C.
