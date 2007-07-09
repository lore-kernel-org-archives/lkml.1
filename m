Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbXGIUTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbXGIUTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXGIUSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:18:40 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:12077 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbXGIUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:18:38 -0400
Message-ID: <46929819.3030205@fr.ibm.com>
Date: Mon, 09 Jul 2007 22:18:33 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 1/16] Round up the API
References: <468DF6F7.1010906@openvz.org> <468DF745.6070705@openvz.org>
In-Reply-To: <468DF745.6070705@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> The set of functions process_session, task_session, process_group
> and task_pgrp is confusing, as the names can be mixed with each other
> when looking at the code for a long time.
> 
> The proposals are to
> * equip the functions that return the integer with _nr suffix to
>   represent that fact,
> * and to make all functions work with task (not process) by making
>   the common prefix of the same name.
> 
> For monotony the routines signal_session() and set_signal_session()
> are replaced with task_session_nr() and set_task_session(), especially
> since they are only used with the explicit task->signal dereference.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
> Acked-by: Serge E. Hallyn <serue@us.ibm.com>

please let's get that one in. 

I think we are all ok with it. right ?

C.
