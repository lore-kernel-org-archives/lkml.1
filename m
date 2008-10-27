Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYJ0QnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYJ0QnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYJ0Qm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:42:58 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43921 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYJ0Qm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:42:57 -0400
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <49059FED.4030202@cs.columbia.edu>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
	 <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu>
	 <20081021124130.a002e838.akpm@linux-foundation.org>
	 <20081021202410.GA10423@us.ibm.com>	<48FE82DF.6030005@cs.columbia.edu>
	 <20081022152804.GA23821@us.ibm.com>	<48FF4EB2.5060206@cs.columbia.edu>
	 <87tzayh27r.wl%peter@chubb.wattle.id.au> <49059FED.4030202@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 09:42:32 -0700
Message-Id: <1225125752.12673.79.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 07:03 -0400, Oren Laadan wrote:
> > In our implementation, we simply refused to checkpoint setid
> programs.
> 
> True. And this works very well for HPC applications.
> 
> However, it doesn't work so well for server applications, for
> instance.
> 
> Also, you could use file system snapshotting to ensure that the file
> system view does not change, and still face the same issue.
> 
> So I'm perfectly ok with deferring this discussion to a later time :)

Oren, is this a good place to stick a process_deny_checkpoint()?  Both
so we refuse to checkpoint, and document this as something that has to
be addressed later?

-- Dave

