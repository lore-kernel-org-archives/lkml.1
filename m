Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZFGXST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZFGXST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZFGXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:18:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59629 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZFGXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:18:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=gqpHAl/1IKfVWBpelZt5mklsKbaE7REsMGfrI/R0tOks+OwUJHj9xxgQgY6ymR1XK
	t7Q47erCOPPqKe59XTKgQ==
Date: Sun, 7 Jun 2009 16:18:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] oom: only oom kill exiting tasks with attached
 memory
In-Reply-To: <661de9470906070712y7b90d1bbn60b110bdb99a0d01@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0906071617010.27806@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com> <661de9470906070712y7b90d1bbn60b110bdb99a0d01@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jun 2009, Balbir Singh wrote:

> Seems like a good change to make. Did you encounter this situation on
> a real machine?
> 

I did, as the result of the chosen task remaining in PF_EXITING state with 
a detached mm following a previous oom kill.
